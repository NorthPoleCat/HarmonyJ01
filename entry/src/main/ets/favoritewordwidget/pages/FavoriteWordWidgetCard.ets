@Entry
@Component
struct FavoriteWordWidgetCard {
  @LocalStorageProp('character') character: string = '暂无收藏'
  @LocalStorageProp('rome') rome: string = '去应用里收藏一些单词吧'
  @LocalStorageProp('meaning') meaning: string = '添加收藏后，就能在桌面快速切换查看。'
  @LocalStorageProp('positionText') positionText: string = '0 / 0'
  @LocalStorageProp('empty') empty: boolean = true
  @LocalStorageProp('canGoPrev') canGoPrev: boolean = false
  @LocalStorageProp('canGoNext') canGoNext: boolean = false

  private readonly routerAction: string = 'router'
  private readonly messageAction: string = 'message'
  private readonly abilityName: string = 'EntryAbility'

  build() {
    Row({ space: 12 }) {
      this.arrowArea('<', 'prev', this.canGoPrev)

      Column({ space: 6 }) {
        Text('收藏单词')
          .fontSize(13)
          .fontColor($r('app.color.favorite_widget_hint_text'))
          .width('100%')
          .textAlign(TextAlign.Center)

        Text(this.character)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.favorite_widget_primary_text'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .textAlign(TextAlign.Center)

        if (this.rome.length > 0) {
          Text(this.rome)
            .fontSize(13)
            .fontColor($r('app.color.favorite_widget_hint_text'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .textAlign(TextAlign.Center)
        }

        Text(this.meaning)
          .fontSize(14)
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
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ left: 4, right: 4, top: 6, bottom: 6 })
      .clip(true)
      .onClick(() => {
        postCardAction(this, {
          action: this.routerAction,
          abilityName: this.abilityName,
          params: {
            url: 'pages/FavoriteWordsView'
          }
        })
      })

      this.arrowArea('>', 'next', this.canGoNext)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 18, right: 18, top: 16, bottom: 16 })
    .borderRadius(24)
    .backgroundColor($r('app.color.favorite_widget_background'))
  }

  @Builder
  private arrowArea(label: string, message: string, enabled: boolean) {
    Row() {
      Text(label)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(enabled ? $r('app.color.favorite_widget_button_text') : $r('app.color.favorite_widget_disabled_text'))
    }
    .width(36)
    .height(72)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(
      enabled ? $r('app.color.favorite_widget_button_background') : $r('app.color.favorite_widget_button_disabled_background')
    )
    .borderRadius(18)
    .opacity(enabled ? 1 : 0.45)
    .enabled(enabled)
    .onClick(() => {
      if (!enabled) {
        return
      }
      postCardAction(this, {
        action: this.messageAction,
        abilityName: this.abilityName,
        params: message
      })
    })
  }
}
