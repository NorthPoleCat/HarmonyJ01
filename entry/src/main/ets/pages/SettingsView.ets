import { router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { JSBridgeClass } from '../models/JSBridgeClass';
import { preferences } from '@kit.ArkData';

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
      .backgroundColor(0xe5aa5a)
      .padding({ left: 10, right: 10 })

      Web({
        src: $rawfile('Lessons/example.html'),
        controller: this.controller
      })
      // .key(`webview_${this.webKey}`)
        .javaScriptProxy({
          object: this.jsBridage,
          name: 'jsBridge',
          methodList: ['loadCss'],
          controller: this.controller
        })
        .height(400)
        .borderWidth(2)
        .borderColor(0xe5aa5a)
        .margin({left: 8, right: 8, top: 8, bottom: 16})

      Row() {
        Text('标注名词')
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.prefs.getSync('nounSet', true) as boolean })
          .onChange((isOn: boolean) => {
            this.prefs.putSync('nounSet', isOn)
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
            this.controller.refresh()
          })
      }
      .padding({left: 8, right: 8, bottom: 4})
      .width('100%')
    }
  }
}