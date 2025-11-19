import { Deformation, DeformationClass } from "../models/DeformationClass"
import { router } from '@kit.ArkUI'

@Component

export struct DeformationCell {

  @State param: [DeformationClass, string] = [new DeformationClass(Deformation.VerbLianYongForm), '']

  build() {
    Row() {
      Text(this.param[0].propertyText())
        .padding({top: 3, bottom: 3, left: 5, right: 5})
        .backgroundColor('#e5aa5a')
        .borderRadius(5)
        .fontColor(Color.White)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/WebViewPage',
            params: { url: this.param[0].jumpUrl(), title: '' }
          })
        })
      Blank()
      Text(this.param[1])
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 8})
  }
}
