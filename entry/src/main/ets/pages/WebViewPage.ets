import { webview } from '@kit.ArkWeb'
import { router } from '@kit.ArkUI'
import { JSBridgeClass } from '../models/JSBridgeClass'
import { AudioPlayer } from '../tools/AudioPlayer'
import common from '@ohos.app.ability.common'
import { ConfigurationConstant } from '@kit.AbilityKit'
import { PremiumAccessStore } from '../tools/PremiumAccessStore'

interface WebViewParams {
  url?: string
  title?: string
}

@Entry
@Component
struct WebViewPage {
  private controller: webview.WebviewController = new webview.WebviewController()
  @State url: string = ''
  private jsBridage: JSBridgeClass = new JSBridgeClass(this.controller)
  @State title: string = ''

  aboutToAppear() {
    const params = router.getParams() as WebViewParams
    if (params?.url) {
      this.url = params.url // ✅ 带类型检查的赋值
      this.title = params.title ?? ''

      if (PremiumAccessStore.requiresUnlock(this.url) &&
        !PremiumAccessStore.isUnlocked(this.getAbilityContext())) {
        router.replaceUrl({
          url: 'pages/PremiumUnlockView',
          params: { url: this.url, title: this.title }
        })
        return
      }
    }
  }

  aboutToDisappear() {
    this.controller.deleteJavaScriptRegister('jsBridge')
    AudioPlayer.getInstance().stop()
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r("sys.symbol.arrow_left"))
          .fontSize(24)
          .fontColor([Color.White])
          .onClick(() => {
            router.back() // 核心返回逻辑
          })

        Text(this.title)
          .fontSize(20)
          .fontColor(Color.White)
          .layoutWeight(1)  // 占据剩余空间
          .textAlign(TextAlign.Center)  // 文字居中

        Row() {
          SymbolGlyph($r("sys.symbol.house_fill"))
            .fontSize(24)
            .fontColor([Color.White])
            .margin({ right: 12 })  // 添加右侧间距
            .onClick(() => {
              router.replaceUrl({
                url: 'pages/Index' // 首页的路径
              })
              router.clear()
            })

          SymbolGlyph($r("sys.symbol.gearshape"))
            .fontSize(24)
            .fontColor([Color.White])
            .onClick(()=>{
              router.replaceUrl({
                url: 'pages/SettingsView'
              })
            })
        }
      }
      .height(44)
      .width('100%')
      .backgroundColor($r('app.color.J01_theme'))
      .padding({ left: 10, right: 10 })

      Web({
        src: $rawfile(this.url),
        controller: this.controller
      })
        .onPageEnd(() => {
          this.injectDarkModeCSS()
        })
        .javaScriptProxy({
          object: this.jsBridage,
          name: 'jsBridge',
          methodList: ['grammar','sentence','loadCss', 'word', 'audioPlay', 'sentencePlay', 'audioReset', 'audioRecycle'],
          controller: this.controller
        })
        .onErrorReceive( () => {
          console.error('网页加载失败')
        })
    }
    .padding({ bottom: 30 })
  }

  private injectDarkModeCSS() {
    let context = getContext(this) as common.UIAbilityContext
    if (context.config.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      const jsCode = `
        var style = document.createElement('style');
        style.innerHTML = 'body { background-color: #000000 !important; color: #ffffff !important; } p { color: #ffffff !important; } .top_tabbarboxs { background-color: #000000 !important; } .bottom_audio { background-color: #1A1D1E !important; }';
        document.head.appendChild(style);
      `
      // 正确的方法
      this.controller.runJavaScript(jsCode)
    }
  }

  private getAbilityContext(): common.UIAbilityContext {
    return getContext(this) as common.UIAbilityContext
  }
}
