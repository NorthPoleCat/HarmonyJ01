import { WordModel } from '../models/WordModel'
import { router } from '@kit.ArkUI'
import { WordPartCell } from '../components/WordPartCell'
import { WordType, WordTypeClass } from '../models/WordTypeClass'
import { Deformation, DeformationClass } from '../models/DeformationClass'
import { DeformationCell } from '../components/DeformationCell'

@Entry
@Component
struct WordView {
  @State wordModel: WordModel = new WordModel()

  aboutToAppear(): void {
    this.wordModel = router.getParams() as WordModel
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
        Text(this.wordModel.character)
          .padding({right: 4})
        if (this.wordModel.rome) { // 判断条件
          Text(`(${this.wordModel.rome})`)
        }
      }
      .padding({left: 16, top: 8, bottom: 8})

      Text(this.wordModel.translate)
        .padding({left: 16, bottom: 8})

      Row() {
        WordPartCell({ param: new WordTypeClass(this.wordModel.partOfSpeech as WordType) })
          .padding({right: 4})

        if (this.wordModel.isAutoVerb == 0) {
          WordPartCell({
            title: '他动词',
            color: '#3366cc',
            jumpUrl: 'grammar/grammar33-01.html'
          })
            .padding({right: 4})
        } else if (this.wordModel.isAutoVerb == 1) {
          WordPartCell({
            title: '自动词',
            color: '#3366cc',
            jumpUrl: 'grammar/grammar33-01.html'
          })
            .padding({right: 4})
        } else if (this.wordModel.isAutoVerb == 2) {
          WordPartCell({
            title: '自动词・他动词',
            color: '#3366cc',
            jumpUrl: 'grammar/grammar33-01.html'
          })
            .padding({right: 4})
        }

        if (this.wordModel.isAdv == 1) {
          WordPartCell({
            title: '副词',
            color: '#8e8e93'
          })
            .padding({right: 4})
        }
      }
      .padding({left: 16, bottom: 8})

      Divider()
      if (this.deformation().length > 0) {
        Text('变形')
          .fontColor('#e5aa5a')
          .padding({left: 16, top: 8, bottom: 8})
      }
      ForEach(this.deformation(), (item: [DeformationClass, string]) => {       // 组件生成函数
        DeformationCell({param: item})
      })
    }
    .alignItems(HorizontalAlign.Start)
  }

  private deformation(): Array<[DeformationClass, string]> {
    const mainChar: string = this.wordModel.character.substring(0, this.wordModel.character.length - 1)
    const lastChar: string = this.wordModel.character.charAt(this.wordModel.character.length - 1)

    const type: WordType = this.wordModel.partOfSpeech as WordType
    if (type == WordType.noun) {
      return []
    }

    if (this.wordModel.character == 'ある') {
      return [
        [new DeformationClass(Deformation.VerbLianYongForm), 'あり'],
        [new DeformationClass(Deformation.VerbMasuForm), 'あります'],
        [new DeformationClass(Deformation.VerbteForm), 'あって'],
        [new DeformationClass(Deformation.VerbnaiForm), 'ない'],
        [new DeformationClass(Deformation.VerbtaForm), 'あった'],
        [new DeformationClass(Deformation.VerbMinglingForm), 'あれ'],
        [new DeformationClass(Deformation.VerbYizhiForm), 'あろう'],
        [new DeformationClass(Deformation.VerbBaForm), 'あれば'],
        [new DeformationClass(Deformation.VerbKenengForm), 'あれる'],
        [new DeformationClass(Deformation.VerbBedongForm), 'あられる'],
        [new DeformationClass(Deformation.VerbShiyiForm), 'あらせる'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), 'あらされる'],
        [new DeformationClass(Deformation.VerbtariForm), 'あったり'],
        [new DeformationClass(Deformation.VerbtaiForm), 'ありたい'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), 'なければ']
      ]
    }

    if (this.wordModel.character == '行く') {
      return [
        [new DeformationClass(Deformation.VerbLianYongForm), '行き'],
        [new DeformationClass(Deformation.VerbMasuForm), '行きます'],
        [new DeformationClass(Deformation.VerbteForm), '行って'],
        [new DeformationClass(Deformation.VerbnaiForm), '行かない'],
        [new DeformationClass(Deformation.VerbtaForm), '行った'],
        [new DeformationClass(Deformation.VerbMinglingForm), '行け'],
        [new DeformationClass(Deformation.VerbYizhiForm), '行こう'],
        [new DeformationClass(Deformation.VerbBaForm), '行けば'],
        [new DeformationClass(Deformation.VerbKenengForm), '行ける'],
        [new DeformationClass(Deformation.VerbBedongForm), '行かれる'],
        [new DeformationClass(Deformation.VerbShiyiForm), '行かせる'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), '行かされる'],
        [new DeformationClass(Deformation.VerbtariForm), '行ったり'],
        [new DeformationClass(Deformation.VerbtaiForm), '行きたい'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), '行かなければ']
      ]
    }

    if (this.wordModel.character == 'いい') {
      return [
        [new DeformationClass(Deformation.AdjLianYongForm), 'よく'],
        [new DeformationClass(Deformation.AdjteForm), 'よくて'],
        [new DeformationClass(Deformation.AdjbaForm), 'よければ'],
        [new DeformationClass(Deformation.AdjJianForm), 'いい'],
        [new DeformationClass(Deformation.AdjJianFouForm), 'よく ない'],
        [new DeformationClass(Deformation.AdjJianGuoForm), 'よかった'],
        [new DeformationClass(Deformation.AdjJianGuoFouForm), 'よく なかった']
      ]
    }

    if (type == WordType.verbFive) {
      if (lastChar == 'う') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'い'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'います'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'って'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'わない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'った'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'え'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'おう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'えば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'える'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'われる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'わせる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'わされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'ったり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'いたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'わなければ']
        ]
      }

      if (lastChar == 'つ') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'ち'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'ちます'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'って'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'たない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'った'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'て'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'とう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'てば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'てる'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'たれる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'たせる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'たされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'ったり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'ちたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'たなければ']
        ]
      }

      if (lastChar == 'る') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'り'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'ります'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'って'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'らない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'った'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'れ'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'ろう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'れば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'れる'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'られる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'らせる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'らされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'ったり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'りたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'らなければ']
        ]
      }

      if (lastChar == 'ぶ') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'び'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'びます'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'んで'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'ばない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'んだ'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'べ'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'ぼう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'べば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'べる'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'ばれる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'ばせる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'ばされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'んだり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'びたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'ばなければ']
        ]
      }

      if (lastChar == 'む') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'み'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'みます'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'んで'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'まない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'んだ'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'め'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'もう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'めば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'める'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'まれる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'ませる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'まされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'んだり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'みたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'まなければ']
        ]
      }

      if (lastChar == 'ぬ') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'に'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'にます'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'んで'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'なない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'んだ'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'ね'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'のう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'ねば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'ねる'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'なれる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'なせる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'なされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'んだり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'にたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'ななければ']
        ]
      }

      if (lastChar == 'く') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'き'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'きます'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'いて'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'かない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'いた'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'け'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'こう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'けば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'ける'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'かれる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'かせる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'かされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'いたり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'きたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'かなければ']
        ]
      }

      if (lastChar == 'ぐ') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'ぎ'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'ぎます'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'いで'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'がない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'いだ'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'げ'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'ごう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'げば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'げる'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'がれる'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'がせる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'がされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'いだり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'ぎたい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'がなければ']
        ]
      }

      if (lastChar == 'す') {
        return [
          [new DeformationClass(Deformation.VerbLianYongForm), mainChar + 'し'],
          [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'します'],
          [new DeformationClass(Deformation.VerbteForm), mainChar + 'して'],
          [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'さない'],
          [new DeformationClass(Deformation.VerbtaForm), mainChar + 'した'],
          [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'せ'],
          [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'そう'],
          [new DeformationClass(Deformation.VerbBaForm), mainChar + 'せば'],
          [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'せる'],
          [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'される'],
          [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'させる'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'さされる'],
          [new DeformationClass(Deformation.VerbtariForm), mainChar + 'したり'],
          [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'したい'],
          [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'さなければ']
        ]
      }
    }

    if (type == WordType.verbOne) {
      return [
        [new DeformationClass(Deformation.VerbLianYongForm), mainChar],
        [new DeformationClass(Deformation.VerbMasuForm), mainChar + 'ます'],
        [new DeformationClass(Deformation.VerbteForm), mainChar + 'て'],
        [new DeformationClass(Deformation.VerbnaiForm), mainChar + 'ない'],
        [new DeformationClass(Deformation.VerbtaForm), mainChar + 'た'],
        [new DeformationClass(Deformation.VerbMinglingForm), mainChar + 'ろ'],
        [new DeformationClass(Deformation.VerbYizhiForm), mainChar + 'よう'],
        [new DeformationClass(Deformation.VerbBaForm), mainChar + 'れば'],
        [new DeformationClass(Deformation.VerbKenengForm), mainChar + 'られる'],
        [new DeformationClass(Deformation.VerbBedongForm), mainChar + 'られる'],
        [new DeformationClass(Deformation.VerbShiyiForm), mainChar + 'させる'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'させられる'],
        [new DeformationClass(Deformation.VerbtariForm), mainChar + 'たり'],
        [new DeformationClass(Deformation.VerbtaiForm), mainChar + 'たい'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), mainChar + 'なければ']
      ]
    }

    if (type == WordType.adjOne) {
      return [
        [new DeformationClass(Deformation.AdjLianYongForm), mainChar + 'く'],
        [new DeformationClass(Deformation.AdjteForm), mainChar + 'くて'],
        [new DeformationClass(Deformation.AdjbaForm), mainChar + 'ければ'],
        [new DeformationClass(Deformation.AdjJianForm), mainChar + 'い'],
        [new DeformationClass(Deformation.AdjJianFouForm), mainChar + 'くない'],
        [new DeformationClass(Deformation.AdjJianGuoForm), mainChar + 'かった'],
        [new DeformationClass(Deformation.AdjJianGuoFouForm), mainChar + 'くなかった']
      ]
    }

    if (type == WordType.adjTwo) {
      return [
        [new DeformationClass(Deformation.AdjLianYongForm), mainChar + 'に'],
        [new DeformationClass(Deformation.AdjteForm), mainChar + 'で'],
        [new DeformationClass(Deformation.AdjbaForm), mainChar + 'であれば'],
        [new DeformationClass(Deformation.AdjJianForm), mainChar + 'だ'],
        [new DeformationClass(Deformation.AdjJianFouForm), mainChar + 'では ない'],
        [new DeformationClass(Deformation.AdjJianGuoForm), mainChar + 'だった'],
        [new DeformationClass(Deformation.AdjJianGuoFouForm), mainChar + 'では なかった']
      ]
    }

    if (type == WordType.verbKa) {
      return [
        [new DeformationClass(Deformation.VerbLianYongForm), 'き'],
        [new DeformationClass(Deformation.VerbMasuForm), 'きます'],
        [new DeformationClass(Deformation.VerbteForm), 'きて'],
        [new DeformationClass(Deformation.VerbnaiForm), 'こない'],
        [new DeformationClass(Deformation.VerbtaForm), 'きた'],
        [new DeformationClass(Deformation.VerbMinglingForm), 'こい'],
        [new DeformationClass(Deformation.VerbYizhiForm), 'こよう'],
        [new DeformationClass(Deformation.VerbBaForm), 'くれば'],
        [new DeformationClass(Deformation.VerbKenengForm), 'こられる'],
        [new DeformationClass(Deformation.VerbBedongForm), 'こられる'],
        [new DeformationClass(Deformation.VerbShiyiForm), 'こさせる'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), 'こさせられる'],
        [new DeformationClass(Deformation.VerbtariForm), 'きたり'],
        [new DeformationClass(Deformation.VerbtaiForm), 'きたい'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), 'こなければ']
      ]
    }

    if (type == WordType.verbSa) {
      return [
        [new DeformationClass(Deformation.VerbLianYongForm), 'し'],
        [new DeformationClass(Deformation.VerbMasuForm), 'します'],
        [new DeformationClass(Deformation.VerbteForm), 'して'],
        [new DeformationClass(Deformation.VerbnaiForm), 'しない'],
        [new DeformationClass(Deformation.VerbtaForm), 'した'],
        [new DeformationClass(Deformation.VerbMinglingForm), 'しろ'],
        [new DeformationClass(Deformation.VerbYizhiForm), 'しよう'],
        [new DeformationClass(Deformation.VerbBaForm), 'すれば'],
        [new DeformationClass(Deformation.VerbKenengForm), 'できる'],
        [new DeformationClass(Deformation.VerbBedongForm), 'される'],
        [new DeformationClass(Deformation.VerbShiyiForm), 'させる'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), 'させられる'],
        [new DeformationClass(Deformation.VerbtariForm), 'したり'],
        [new DeformationClass(Deformation.VerbtaiForm), 'したい'],
        [new DeformationClass(Deformation.VerbShiyiBeidongForm), 'しなければ']
      ]
    }
    return []
  }
}