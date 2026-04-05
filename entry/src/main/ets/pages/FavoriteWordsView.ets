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
            .fontColor($r('app.color.favorite_hint_text'))
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
                    .fontColor($r('app.color.favorite_primary_text'))
                    .fontWeight(FontWeight.Bold)
                    .width('100%')
                    .textAlign(TextAlign.Start)

                  if (item.rome) {
                    Text(item.rome as string)
                      .fontSize(13)
                      .fontColor($r('app.color.favorite_hint_text'))
                      .padding({ top: 4 })
                      .width('100%')
                      .textAlign(TextAlign.Start)
                  }

                  Text(item.translate ?? '')
                    .fontSize(14)
                    .fontColor($r('app.color.favorite_secondary_text'))
                    .padding({ top: 6 })
                    .width('100%')
                    .textAlign(TextAlign.Start)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Button('取消收藏')
                  .fontSize(13)
                  .height(32)
                  .backgroundColor($r('app.color.favorite_button_background'))
                  .fontColor($r('app.color.J01_theme'))
                  .onClick(() => {
                    this.removeFavorite(item)
                  })
              }
              .width('100%')
              .padding({ left: 12, right: 12, top: 12, bottom: 12 })
            }
            .backgroundColor($r('app.color.favorite_card_background'))
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
    .backgroundColor($r('app.color.favorite_page_background'))
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
