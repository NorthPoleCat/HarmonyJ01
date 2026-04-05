# 华为 IAP 接入配置清单

## 1. 代码侧已完成内容

当前工程已经接入以下 IAP 流程：

- 第七单元起内容门禁
- 解锁页商品查询
- 发起一次性非消耗型商品购买
- 购买成功后 `finishPurchase`
- 启动时与进入解锁页时恢复已购状态

关键代码位置：

- [PremiumIapService.ets](/Users/xunliu/Harmony/Japanese01/entry/src/main/ets/tools/PremiumIapService.ets)
- [PremiumUnlockView.ets](/Users/xunliu/Harmony/Japanese01/entry/src/main/ets/pages/PremiumUnlockView.ets)
- [PremiumAccessStore.ets](/Users/xunliu/Harmony/Japanese01/entry/src/main/ets/tools/PremiumAccessStore.ets)
- [PremiumProductConfig.ets](/Users/xunliu/Harmony/Japanese01/entry/src/main/ets/constants/PremiumProductConfig.ets)

## 2. AppGallery Connect 配置步骤

### 2.1 开通 IAP 服务

1. 登录 AppGallery Connect。
2. 进入你的应用。
3. 确认应用已开通应用内购 IAP 服务。
4. 如果 AGC 需要补充结算、协议或商户信息，先完成这些前置配置。

### 2.2 创建一次性商品

1. 在 IAP 商品管理中创建一个新商品。
2. 商品类型选择：
   `Non-Consumable` / 非消耗型商品
3. 商品用途建议：
   “后续课程永久解锁”
4. 记录商品 ID。

建议示例：

```text
japanese01_premium_unlock
```

### 2.3 填写商品信息

建议至少配置：

- 商品名称：后续课程解锁
- 商品描述：永久解锁第七单元到第十二单元内容
- 价格：按你的计划设置
- 销售区域：确保覆盖你的测试账号所在区域

### 2.4 发布商品

1. 提交商品审核或发布。
2. 确保商品状态是可销售。
3. 如果商品未发布，客户端通常会报：
   商品无效 / 当前地区未发布 / 查询不到商品

## 3. 项目中需要修改的唯一商品 ID

打开：

- [PremiumProductConfig.ets](/Users/xunliu/Harmony/Japanese01/entry/src/main/ets/constants/PremiumProductConfig.ets)

把这里的值替换成 AGC 中真实的商品 ID：

```ts
static readonly PRODUCT_ID: string = 'japanese01_premium_unlock'
```

## 4. 联调前检查项

在真机测试前，建议逐项确认：

- 应用使用的 `bundleName` 与 AGC 上保持一致
- 安装到设备上的包来自当前同一个应用
- 测试设备支持华为 IAP
- 设备已登录华为账号
- 当前华为账号所在地区支持 IAP
- 商品已在该地区发布
- 测试账号有购买权限

## 5. 真机测试步骤

### 5.1 首次购买测试

1. 安装当前应用到真机。
2. 进入首页，点击第七单元或之后的课程。
3. 应跳转到“解锁后续内容”页面。
4. 页面应能显示商品名称和价格。
5. 点击“购买并解锁”。
6. 完成支付。
7. 支付完成后应自动进入目标课程页面。

### 5.2 恢复购买测试

1. 卸载重装应用，或清空应用数据。
2. 再次进入第七单元后的内容。
3. 点击“恢复购买”。
4. 若账号下存在已购记录，应恢复解锁状态。

### 5.3 已购再次购买测试

1. 使用已购买账号再次点击购买。
2. 应提示已购买或恢复已购状态。
3. 页面应变为可直接进入内容。

## 6. 常见问题排查

### 6.1 查不到商品

优先检查：

- 商品 ID 是否填写正确
- 商品是否已发布
- 商品销售地区是否覆盖当前账号
- 应用与商品是否属于同一个 AGC 应用

### 6.2 提示未授权

优先检查：

- 应用是否已开通 IAP 服务
- AGC 配置是否完整
- 安装包是否属于对应应用版本

### 6.3 提示未登录华为账号

处理方式：

- 在设备上登录华为账号
- 重新打开应用后再试

### 6.4 已购买但仍被拦截

处理方式：

1. 进入解锁页
2. 点击“恢复购买”
3. 若仍失败，检查当前登录账号是否就是购买账号

## 7. 现在这套实现的边界

当前代码已经是真正调用 HarmonyOS / 华为 IAP 接口，但仍建议注意：

- 尚未接服务端验签
- 当前解锁逻辑属于客户端授予型
- 对“一次性课程解锁”这种场景通常已足够

如果你后续希望进一步提高安全性，可以继续补：

- 服务端验签
- 服务端记账
- 多端购买状态同步
- 更完整的订单日志
