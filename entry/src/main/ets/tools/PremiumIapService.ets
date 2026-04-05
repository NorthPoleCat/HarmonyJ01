import { iap } from '@kit.IAPKit'
import { util } from '@kit.ArkTS'
import common from '@ohos.app.ability.common'
import { BusinessError } from '@kit.BasicServicesKit'
import { PremiumAccessStore } from './PremiumAccessStore'
import { PremiumProductConfig } from '../constants/PremiumProductConfig'

export interface PremiumProductInfo {
  id: string
  name: string
  description: string
  price: string
}

interface PremiumPurchasePayload {
  productId?: string
  purchaseToken?: string
  purchaseOrderId?: string
}

interface ErrorWithCode {
  code?: number
  message?: string
}

export class PremiumIapService {
  static readonly PRODUCT_ID: string = PremiumProductConfig.PRODUCT_ID
  static readonly PRODUCT_TYPE: iap.ProductType = iap.ProductType.NONCONSUMABLE

  static async queryPremiumProduct(context: common.UIAbilityContext): Promise<PremiumProductInfo | null> {
    await iap.queryEnvironmentStatus(context)
    const products = await iap.queryProducts(context, {
      productType: PremiumIapService.PRODUCT_TYPE,
      productIds: [PremiumIapService.PRODUCT_ID]
    })

    if (products.length < 1) {
      return null
    }

    const product = products[0]
    return {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.localPrice ?? product.price
    }
  }

  static async syncUnlockStatus(context: common.UIAbilityContext): Promise<boolean> {
    try {
      await iap.queryEnvironmentStatus(context)

      let continuationToken: string | undefined = undefined
      do {
        const result: iap.QueryPurchaseResult = await iap.queryPurchases(context, {
          productType: PremiumIapService.PRODUCT_TYPE,
          queryType: iap.PurchaseQueryType.ALL,
          continuationToken: continuationToken
        })

        const matched: boolean = result.purchaseDataList.some((item: string): boolean => {
          const payload: PremiumPurchasePayload = PremiumIapService.parsePurchasePayload(item)
          return payload.productId === PremiumIapService.PRODUCT_ID
        })

        if (matched) {
          PremiumAccessStore.unlock(context)
          return true
        }

        continuationToken = result.continuationToken
      } while (continuationToken)
    } catch (_err) {
      return PremiumAccessStore.isUnlocked(context)
    }

    return PremiumAccessStore.isUnlocked(context)
  }

  static async purchasePremium(context: common.UIAbilityContext): Promise<void> {
    await iap.queryEnvironmentStatus(context)

    const result = await iap.createPurchase(context, {
      productId: PremiumIapService.PRODUCT_ID,
      productType: PremiumIapService.PRODUCT_TYPE,
      developerPayload: 'japanese01_premium_unlock'
    })

    const payload = PremiumIapService.parsePurchasePayload(result.purchaseData)
    if (payload.productId !== PremiumIapService.PRODUCT_ID) {
      throw new Error('购买返回的商品与预期不一致')
    }

    if (!payload.purchaseToken || !payload.purchaseOrderId) {
      throw new Error('未获取到完整的购买凭据')
    }

    await iap.finishPurchase(context, {
      productType: PremiumIapService.PRODUCT_TYPE,
      purchaseToken: payload.purchaseToken,
      purchaseOrderId: payload.purchaseOrderId
    })

    PremiumAccessStore.unlock(context)
  }

  static getErrorMessage(err: Object): string {
    const businessError = err as BusinessError
    const rawError = err as ErrorWithCode
    switch (businessError.code) {
      case 1001860000:
        return '已取消购买'
      case 1001860001:
        return '华为支付服务暂时不可用，请稍后重试'
      case 1001860002:
        return '应用未完成 IAP 授权，请检查 AppGallery Connect 配置'
      case 1001860003:
        return '商品信息无效，请检查商品 ID 配置'
      case 1001860004:
        return '请求过于频繁，请稍后再试'
      case 1001860005:
        return '网络异常，请稍后再试'
      case 1001860007:
        return '该商品所在应用尚未在当前地区发布'
      case 1001860050:
        return '请先登录华为账号后再购买'
      case 1001860051:
        return '你已购买过该内容，正在恢复解锁状态'
      case 1001860053:
        return '该订单已完成处理，正在恢复解锁状态'
      case 1001860054:
        return '当前华为账号所在国家或地区暂不支持应用内购'
      case 1001860056:
        return '当前账号暂时无法购买'
      default:
        return rawError.message ?? '购买失败，请稍后重试'
    }
  }

  private static parsePurchasePayload(rawData: string): PremiumPurchasePayload {
    const normalized = PremiumIapService.normalizePayload(rawData)
    try {
      return JSON.parse(normalized) as PremiumPurchasePayload
    } catch (_err) {
      return {}
    }
  }

  private static normalizePayload(rawData: string): string {
    const trimmed = rawData.trim()
    if (trimmed.startsWith('{')) {
      return trimmed
    }

    const segments = trimmed.split('.')
    if (segments.length === 3) {
      try {
        const helper = new util.Base64Helper()
        const payloadBytes = helper.decodeSync(segments[1], util.Type.BASIC_URL_SAFE)
        const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
        return textDecoder.decodeToString(payloadBytes)
      } catch (_err) {
        return trimmed
      }
    }

    return trimmed
  }
}
