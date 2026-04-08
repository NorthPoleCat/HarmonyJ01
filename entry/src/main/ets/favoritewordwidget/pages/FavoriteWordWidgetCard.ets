@Entry
@Component
struct FavoriteWordWidgetCard {
  character: string = '暂无收藏'
  rome: string = '去应用里收藏一些单词吧'
  meaning: string = '添加收藏后，就能在桌面快速切换查看。'
  positionText: string = '0 / 0'
  empty: boolean = true
  canGoPrev: boolean = false
  canGoNext: boolean = false

  build() {
    Row({ space: 12 }) {
      this.arrowButton('<', 'prev', this.canGoPrev)

      Column({ space: 8 }) {
        Text('收藏单词')
          .fontSize(14)
          .fontColor($r('app.color.favorite_widget_hint_text'))
          .width('100%')
          .textAlign(TextAlign.Center)

        Text(this.character)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.favorite_widget_primary_text'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .textAlign(TextAlign.Center)

        if (this.rome.length > 0) {
          Text(this.rome)
            .fontSize(14)
            .fontColor($r('app.color.favorite_widget_hint_text'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .textAlign(TextAlign.Center)
        }

        Text(this.meaning)
          .fontSize(15)
          .fontColor($r('app.color.favorite_widget_secondary_text'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .textAlign(TextAlign.Center)

        Text(this.positionText)
          .fontSize(12)
          .fontColor($r('app.color.favorite_widget_hint_text'))
          .width('100%')
          .textAlign(TextAlign.Center)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      this.arrowButton('>', 'next', this.canGoNext)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 18, right: 18, top: 16, bottom: 16 })
    .borderRadius(24)
    .backgroundColor($r('app.color.favorite_widget_background'))
  }

  @Builder
  private arrowButton(label: string, message: string, enabled: boolean) {
    Button(label)
      .width(42)
      .height(42)
      .fontSize(22)
      .fontWeight(FontWeight.Bold)
      .fontColor(enabled ? $r('app.color.favorite_widget_button_text') : $r('app.color.favorite_widget_disabled_text'))
      .backgroundColor(
        enabled ? $r('app.color.favorite_widget_button_background') : $r('app.color.favorite_widget_button_disabled_background')
      )
      .enabled(enabled)
      .onClick(() => {
        postCardAction(this, {
          action: 'message',
          params: {
            message: message
          }
        })
      })
  }
}
