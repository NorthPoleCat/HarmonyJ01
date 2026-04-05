import { router } from '@kit.ArkUI'
import common from '@ohos.app.ability.common'
import { WordModel } from '../models/WordModel'
import { FavoriteWordStore } from '../tools/FavoriteWordStore'

@Entry
@Component
struct FavoriteWordsView {
  @State favoriteWords: Array<WordModel> = []

  aboutToAppear(): void {
    this.reloadFavorites()
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

        Text('收藏单词')
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

      if (this.favoriteWords.length === 0) {
        Column() {
          Blank()
          Text('还没有收藏单词')
            .fontSize(16)
            .fontColor('#8e8e93')
          Blank()
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 8 }) {
          ForEach(this.favoriteWords, (item: WordModel) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item.character)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .width('100%')
                    .textAlign(TextAlign.Start)

                  if (item.rome) {
                    Text(item.rome as string)
                      .fontSize(13)
                      .fontColor('#8e8e93')
                      .padding({ top: 4 })
                      .width('100%')
                      .textAlign(TextAlign.Start)
                  }

                  Text(item.translate ?? '')
                    .fontSize(14)
                    .fontColor('#666666')
                    .padding({ top: 6 })
                    .width('100%')
                    .textAlign(TextAlign.Start)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Button('取消收藏')
                  .fontSize(13)
                  .height(32)
                  .backgroundColor('#f4e3c4')
                  .fontColor($r('app.color.J01_theme'))
                  .onClick(() => {
                    this.removeFavorite(item)
                  })
              }
              .width('100%')
              .padding({ left: 12, right: 12, top: 12, bottom: 12 })
            }
            .backgroundColor(Color.White)
            .borderRadius(8)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WordView',
                params: item
              })
            })
          }, (item: WordModel) => this.wordKey(item))
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 8, right: 8, top: 8, bottom: 8 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f7f7f7')
  }

  private reloadFavorites(): void {
    const context = getContext(this) as common.UIAbilityContext
    this.favoriteWords = FavoriteWordStore.list(context)
  }

  private removeFavorite(item: WordModel): void {
    const context = getContext(this) as common.UIAbilityContext
    FavoriteWordStore.remove(context, item)
    this.reloadFavorites()
  }

  private wordKey(item: WordModel): string {
    return `${item.character}|${item.rome ?? ''}|${item.translate ?? ''}`
  }
}
