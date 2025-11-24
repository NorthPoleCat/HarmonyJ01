import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { JSBridgeClass } from '../models/JSBridgeClass';

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
    }
  }

  aboutToDisappear() {
    this.controller.deleteJavaScriptRegister('jsBridge')
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
      .backgroundColor(0xe5aa5a)
      .padding({ left: 10, right: 10 })

      Web({
        src: $rawfile(this.url),
        controller: this.controller
      })
      // .key(`webview_${this.webKey}`)
        .javaScriptProxy({
          object: this.jsBridage,
          name: 'jsBridge',
          methodList: ['grammar','sentence','loadCss', 'word', 'audioPlay'],
          controller: this.controller
        })
        .onErrorReceive( () => {
          console.error('网页加载失败')
        })
    }
    .padding({ bottom: 30 })
  }
}