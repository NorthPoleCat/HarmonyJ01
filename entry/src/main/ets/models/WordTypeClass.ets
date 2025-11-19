import { Deformation, DeformationClass } from "./DeformationClass"

export enum WordType {
  noun = 0,
  adjOne,
  adjTwo,
  verbFive,
  verbOne,
  verbKa,
  verbSa
}

export class WordTypeClass {
  private value: WordType

  constructor(value: WordType) {
    this.value = value
  }

  partString(): string {
    switch (this.value) {
      case WordType.noun:
        return '名词'
      case WordType.adjOne:
        return '一类形容词'
      case WordType.adjTwo:
        return '二类形容词'
      case WordType.verbFive:
        return '五段动词'
      case WordType.verbOne:
        return '一段动词'
      case WordType.verbKa:
        return 'カ变动词'
      case WordType.verbSa:
        return 'サ变动词'
    }
  }

  partUrl(): string {
    switch (this.value) {
      case WordType.adjOne:
        return 'grammar/grammar09-01.html'
      case WordType.adjTwo:
        return 'grammar/grammar10-01.html'
      case WordType.verbFive:
        return 'grammar/grammarCommon02.html'
      case WordType.verbOne:
        return 'grammar/grammarCommon03.html'
      default:
        return ''
    }
  }

  bgColor(): string {
    switch (this.value) {
      case WordType.adjOne:
        return '#6aace0'
      case WordType.adjTwo:
        return '#54b884'
      case WordType.verbFive:
        return '#e86b8a'
      case WordType.verbOne:
        return '#f9c76e'
      default:
        return '#8e8e93'
    }
  }
}