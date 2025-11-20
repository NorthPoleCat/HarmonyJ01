import { router } from '@kit.ArkUI'
import { InvolvedGrammarModel, SentenceModel } from '../models/SentenceModel'

@Entry
@Component
struct SentenceView {
  @State senModel: SentenceModel = new SentenceModel()

  aboutToAppear(): void {
    this.senModel = router.getParams() as SentenceModel
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

      Text(this.senModel.character)
        .fontWeight(FontWeight.Bold)
        .padding({left: 16, top: 8, bottom: 16})

      Text(this.senModel.translate)
        .fontWeight(FontWeight.Bold)
        .padding({left: 16, bottom: 16})

      Divider()
        .padding({bottom: 8})

      if (this.senModel.Tips.length > 0) {
        Text('词组')
          .fontColor(0xe5aa5a)
          .padding({left: 16, bottom: 8})

        ForEach(this.senModel.Tips, (item: string) => {       // 组件生成函数
          Text(item)
            .padding({ left: 16, right: 16, bottom: 16})
        })
      }

      if (this.senModel.involvedGrammar.length > 0) {
        Text('语法')
          .fontColor(0xe5aa5a)
          .padding({left: 16, bottom: 16})

        ForEach(this.senModel.involvedGrammar, (item: InvolvedGrammarModel) => {       // 组件生成函数
          Text(item.grammarName)
            .padding({ left: 16, right: 16, bottom: 8})
            .fontColor(Color.Blue)
            .onClick(()=> {
              router.pushUrl({
                url: 'pages/WebViewPage',
                params: { url: 'grammar/grammar' + item.grammarNum + '.html', title: '' }
              })
            })
        })
      }

    }
    .alignItems(HorizontalAlign.Start)
  }

}