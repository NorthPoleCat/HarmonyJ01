import { router } from '@kit.ArkUI'
import common from '@ohos.app.ability.common'
import { PremiumAccessStore } from '../tools/PremiumAccessStore'
import { PremiumIapService, PremiumProductInfo } from '../tools/PremiumIapService'

interface PremiumUnlockParams {
  url?: string
  title?: string
}

@Entry
@Component
struct PremiumUnlockView {
  @State targetUrl: string = ''
  @State targetTitle: string = ''
  @State isUnlocked: boolean = false
  @State priceText: string = ''
  @State productName: string = '后续课程解锁'
  @State descriptionText: string = '第七单元及之后内容需要一次性解锁后访问。'
  @State messageText: string = ''
  @State isLoading: boolean = true
  @State isPurchasing: boolean = false

  aboutToAppear(): void {
    const params = router.getParams() as PremiumUnlockParams
    this.targetUrl = params?.url ?? ''
    this.targetTitle = params?.title ?? ''
    this.isUnlocked = PremiumAccessStore.isUnlocked(this.getAbilityContext())
    this.loadProductInfo()
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r("sys.symbol.arrow_left"))
          .fontSize(24)
          .fontColor([Color.White])
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.back()
          })

        Text('解锁后续内容')
          .fontSize(20)
          .fontColor(Color.White)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank()
          .width(24)
      }
      .height(44)
      .width('100%')
      .backgroundColor($r('app.color.J01_theme'))
      .padding({ left: 10, right: 10 })

      Column({ space: 16 }) {
        Text(this.productName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.favorite_primary_text'))
          .textAlign(TextAlign.Center)

        if (this.targetTitle.length > 0) {
          Text(`当前内容：${this.targetTitle}`)
            .fontSize(14)
            .fontColor($r('app.color.favorite_secondary_text'))
            .textAlign(TextAlign.Center)
        }

        Text(this.descriptionText)
          .fontSize(14)
          .fontColor($r('app.color.favorite_secondary_text'))
          .textAlign(TextAlign.Center)

        if (this.priceText.length > 0 && !this.isUnlocked) {
          Text(`价格：${this.priceText}`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.J01_theme'))
            .textAlign(TextAlign.Center)
        }

        Button(this.buttonText())
          .width('100%')
          .height(44)
          .backgroundColor($r('app.color.J01_theme'))
          .fontColor(Color.White)
          .enabled(!this.isLoading && !this.isPurchasing)
          .onClick(() => {
            this.handleAction()
          })

        if (!this.isUnlocked) {
          Button('恢复购买')
            .width('100%')
            .height(40)
            .backgroundColor($r('app.color.favorite_button_background'))
            .fontColor($r('app.color.J01_theme'))
            .enabled(!this.isLoading && !this.isPurchasing)
            .onClick(() => {
              this.restorePurchase()
            })
        }

        if (this.messageText.length > 0) {
          Text(this.messageText)
            .fontSize(12)
            .fontColor($r('app.color.favorite_hint_text'))
            .textAlign(TextAlign.Center)
        }

        if (!this.isUnlocked) {
          Text('如你已购买过但仍被拦截，可点击“恢复购买”重新同步订单状态。')
            .fontSize(12)
            .fontColor($r('app.color.favorite_hint_text'))
            .textAlign(TextAlign.Center)

          Text('购买前请确认设备已登录华为账号，且测试账号有权限访问当前商品。')
            .fontSize(12)
            .fontColor($r('app.color.favorite_hint_text'))
            .textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .padding(20)
      .backgroundColor($r('app.color.favorite_card_background'))
      .borderRadius(16)
      .margin({ left: 16, right: 16, top: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.favorite_page_background'))
  }

  private openTarget(): void {
    if (this.targetUrl.length < 1) {
      router.back()
      return
    }

    router.replaceUrl({
      url: 'pages/WebViewPage',
      params: { url: this.targetUrl, title: this.targetTitle }
    })
  }

  private handleAction(): void {
    if (this.isUnlocked) {
      this.openTarget()
      return
    }

    if (this.isLoading || this.isPurchasing) {
      return
    }

    this.purchasePremium()
  }

  private loadProductInfo(): void {
    this.isLoading = true
    this.messageText = '正在检查购买状态...'

    PremiumIapService.syncUnlockStatus(this.getAbilityContext())
      .then((unlocked: boolean) => {
        this.isUnlocked = unlocked
        if (unlocked) {
          this.messageText = '已检测到购买记录，可直接进入内容。'
          this.isLoading = false
          return
        }

        return PremiumIapService.queryPremiumProduct(this.getAbilityContext())
          .then((product: PremiumProductInfo | null) => {
            if (product) {
              this.productName = product.name
              this.descriptionText = product.description.length > 0 ?
                product.description : this.descriptionText
              this.priceText = product.price
              this.messageText = '购买后永久解锁第七单元到第十二单元内容。'
            } else {
              this.messageText = '未查询到商品信息，请检查应用内购商品配置。'
            }
            this.isLoading = false
          })
      })
      .catch((err: Object) => {
        this.messageText = PremiumIapService.getErrorMessage(err)
        this.isLoading = false
      })
  }

  private purchasePremium(): void {
    this.isPurchasing = true
    this.messageText = '正在拉起支付...'

    PremiumIapService.purchasePremium(this.getAbilityContext())
      .then(() => {
        this.isUnlocked = true
        this.isPurchasing = false
        this.messageText = '购买成功，已完成解锁。'
        this.openTarget()
      })
      .catch((err: Object) => {
        this.isPurchasing = false
        const message = PremiumIapService.getErrorMessage(err)
        if ((err as { code?: number }).code === 1001860051) {
          PremiumIapService.syncUnlockStatus(this.getAbilityContext())
            .then((unlocked: boolean) => {
              this.isUnlocked = unlocked
              this.messageText = unlocked ? '已恢复购买记录，可直接进入内容。' : message
            })
            .catch((_syncErr: Object) => {
              this.messageText = message
            })
          return
        }
        this.messageText = message
      })
  }

  private restorePurchase(): void {
    if (this.isLoading || this.isPurchasing) {
      return
    }

    this.isLoading = true
    this.messageText = '正在恢复购买记录...'

    PremiumIapService.syncUnlockStatus(this.getAbilityContext())
      .then((unlocked: boolean) => {
        this.isUnlocked = unlocked
        this.isLoading = false
        this.messageText = unlocked ? '已恢复购买记录，可直接进入内容。' : '未找到已购记录，请确认当前华为账号是否完成过购买。'
      })
      .catch((err: Object) => {
        this.isLoading = false
        this.messageText = PremiumIapService.getErrorMessage(err)
      })
  }

  private buttonText(): string {
    if (this.isPurchasing) {
      return '处理中...'
    }

    if (this.isLoading) {
      return '加载中...'
    }

    if (this.isUnlocked) {
      return '已解锁，进入内容'
    }

    if (this.priceText.length > 0) {
      return `购买并解锁 ${this.priceText}`
    }

    return '购买并解锁'
  }

  private getAbilityContext(): common.UIAbilityContext {
    return getContext(this) as common.UIAbilityContext
  }
}
