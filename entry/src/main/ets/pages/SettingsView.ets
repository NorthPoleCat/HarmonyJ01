import { router } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'
import { JSBridgeClass } from '../models/JSBridgeClass'
import { preferences } from '@kit.ArkData'
import common from '@ohos.app.ability.common'
import { ConfigurationConstant } from '@kit.AbilityKit'

@Entry
@Component

struct SettingsView {

  private controller: webview.WebviewController = new webview.WebviewController()
  private jsBridage: JSBridgeClass = new JSBridgeClass(this.controller)
  private prefs: preferences.Preferences = preferences.getPreferencesSync(getContext(), { name: 'userSettings' })

  build() {
    Column() {
      Row() {
        SymbolGlyph($r("sys.symbol.close_sidebar"))
          .fontSize(24)
          .fontColor([Color.White])
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.back() // 核心返回逻辑
          })
      }
      .height(44)
      .width('100%')
      .backgroundColor($r('app.color.J01_theme'))
      .padding({ left: 10, right: 10 })

      Web({
        src: $rawfile('Lessons/example.html'),
        controller: this.controller
      })
      // .key(`webview_${this.webKey}`)
        .onPageEnd(() => {
          this.injectDarkModeCSS()
        })
        .javaScriptProxy({
          object: this.jsBridage,
          name: 'jsBridge',
          methodList: ['loadCss'],
          controller: this.controller
        })
        .height(400)
        .borderWidth(2)
        .borderColor($r('app.color.J01_theme'))
        .margin({left: 8, right: 8, top: 8, bottom: 16})

      Row() {
        Text('标注名词')
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.prefs.getSync('nounSet', true) as boolean })
          .onChange((isOn: boolean) => {
            this.prefs.putSync('nounSet', isOn)
            this.prefs.flushSync()
            this.controller.refresh()
          })
      }
      .padding({left: 8, right: 8, bottom: 4})
      .width('100%')

      Row() {
        Text('标注动词')
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.prefs.getSync('verbSet', true) as boolean })
          .onChange((isOn: boolean) => {
            this.prefs.putSync('verbSet', isOn)
            this.prefs.flushSync()
            this.controller.refresh()
          })
      }
      .padding({left: 8, right: 8, bottom: 4})
      .width('100%')

      Row() {
        Text('标注形容词')
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.prefs.getSync('adjSet', true) as boolean })
          .onChange((isOn: boolean) => {
            this.prefs.putSync('adjSet', isOn)
            this.prefs.flushSync()
            this.controller.refresh()
          })
      }
      .padding({left: 8, right: 8, bottom: 4})
      .width('100%')

      Row() {
        Text('标注中文')
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.prefs.getSync('chSet', true) as boolean })
          .onChange((isOn: boolean) => {
            this.prefs.putSync('chSet', isOn)
            this.prefs.flushSync()
            this.controller.refresh()
          })
      }
      .padding({left: 8, right: 8, bottom: 4})
      .width('100%')

      Row() {
        Text('标注假名')
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.prefs.getSync('hiraSet', true) as boolean })
          .onChange((isOn: boolean) => {
            this.prefs.putSync('hiraSet', isOn)
            this.prefs.flushSync()
            this.controller.refresh()
          })
      }
      .padding({left: 8, right: 8, bottom: 4})
      .width('100%')
    }
  }

  private injectDarkModeCSS() {
    let context = getContext(this) as common.UIAbilityContext
    if (context.config.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      const jsCode = `
        var style = document.createElement('style');
        style.innerHTML = 'body { background-color: #000000 !important; color: #ffffff !important; } p { color: #ffffff !important; }';
        document.head.appendChild(style);
      `
      // 正确的方法
      this.controller.runJavaScript(jsCode)
    }
  }
}