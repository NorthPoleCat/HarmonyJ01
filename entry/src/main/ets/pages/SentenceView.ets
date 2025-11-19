import { router } from '@kit.ArkUI'

@Entry
@Component
struct SentenceView {
  // @State wordModel: WordModel = new WordModel()

  aboutToAppear(): void {
    // this.wordModel = router.getParams() as WordModel
  }

  build() {
    Column() {
      Row() {
        SymbolGlyph($r("sys.symbol.arrow_left"))
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

      Row() {
        // Text(this.wordModel.character)
        //   .padding({right: 4})
        // if (this.wordModel.rome) { // 判断条件
        //   Text(`(${this.wordModel.rome})`)
        // }
      }
      .padding({left: 16, top: 8, bottom: 8})

      // Text(this.wordModel.translate)
      //   .padding({left: 16, bottom: 8})



      Divider()

    }
    .alignItems(HorizontalAlign.Start)
  }

}