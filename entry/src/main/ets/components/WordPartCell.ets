import { WordType, WordTypeClass } from "../models/WordTypeClass"
import { router } from '@kit.ArkUI'

@Component

export struct WordPartCell {

  @State title: string = ''
  @State color: string = ''
  @State jumpUrl: string = ''

  @State param: WordTypeClass = new WordTypeClass(WordType.verbFive)

  aboutToAppear(): void {
    if (this.color.length > 1) {
      return
    }
    this.title = this.param.partString()
    this.color = this.param.bgColor()
    this.jumpUrl = this.param.partUrl()
  }

  build() {
    Text(this.title)
      .padding({top: 3, bottom: 3, left: 5, right: 5})
      .backgroundColor(this.color)
      .borderRadius(5)
      .fontColor(Color.White)
      .onClick(() => {
        if (this.jumpUrl.length > 1) {
          router.pushUrl({
            url: 'pages/WebViewPage',
            params: { url: this.jumpUrl, title: '' }
          })
        }
      })
  }
}