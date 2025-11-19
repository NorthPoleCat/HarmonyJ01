import { retrieval } from "@kit.DataAugmentationKit"

export enum Deformation {
  VerbLianYongForm,
  VerbMasuForm,
  VerbteForm,
  VerbnaiForm,
  VerbtaForm,
  VerbMinglingForm,
  VerbYizhiForm,
  VerbBaForm,
  VerbKenengForm,
  VerbBedongForm,
  VerbShiyiForm,
  VerbShiyiBeidongForm,

  VerbtaiForm,
  VerbtariForm,
  VerbnakerebaForm,

  AdjLianYongForm,
  AdjteForm,
  AdjbaForm,
  AdjJianForm,
  AdjJianFouForm,
  AdjJianGuoForm,
  AdjJianGuoFouForm
}

export class DeformationClass {
  private value: Deformation

  constructor(value: Deformation) {
    this.value = value
  }

  propertyText(): string {
    switch (this.value) {
      case Deformation.VerbLianYongForm:
        return '连用形'
      case Deformation.VerbMasuForm:
        return 'ます形'
      case Deformation.VerbteForm:
        return 'て形'
      case Deformation.VerbnaiForm:
        return 'ない形'
      case Deformation.VerbtaForm:
        return 'た形'
      case Deformation.VerbMinglingForm:
        return '命令形'
      case Deformation.VerbYizhiForm:
        return '意志形'
      case Deformation.VerbBaForm:
        return 'ば形'
      case Deformation.VerbKenengForm:
        return '可能形'
      case Deformation.VerbBedongForm:
        return '被动形'
      case Deformation.VerbShiyiForm:
        return '使役形'
      case Deformation.VerbShiyiBeidongForm:
        return '使役被动形'
      case Deformation.VerbtaiForm:
        return 'たい形'
      case Deformation.VerbtariForm:
        return 'たり形'
      case Deformation.VerbnakerebaForm:
        return 'なければ形'
      case Deformation.AdjLianYongForm:
        return '连用形'
      case Deformation.AdjteForm:
        return 'て形'
      case Deformation.AdjbaForm:
        return 'ば形'
      case Deformation.AdjJianForm:
        return '简体形'
      case Deformation.AdjJianFouForm:
        return '简体否定'
      case Deformation.AdjJianGuoForm:
        return '简体过去'
      case Deformation.AdjJianGuoFouForm:
        return '简体过去否定'
    }
  }

  jumpUrl(): string {
    switch (this.value) {
      case Deformation.VerbLianYongForm:
        return 'grammar/grammarCommon01.html'
      case Deformation.VerbMasuForm:
        return 'grammar/grammar05-02.html'
      case Deformation.VerbteForm:
        return 'grammar/grammar14-01.html'
      case Deformation.VerbnaiForm:
        return 'grammar/grammar19-01.html'
      case Deformation.VerbtaForm:
        return 'grammar/grammar21-01.html'
      case Deformation.VerbMinglingForm:
        return 'grammar/grammar29-01.html'
      case Deformation.VerbYizhiForm:
        return 'grammar/grammar30-01.html'
      case Deformation.VerbBaForm:
        return 'grammar/grammar37-01.html'
      case Deformation.VerbKenengForm:
        return 'grammar/grammar38-01.html'
      case Deformation.VerbBedongForm:
        return 'grammar/grammar41-01.html'
      case Deformation.VerbShiyiForm:
        return 'grammar/grammar43-01.html'
      case Deformation.VerbShiyiBeidongForm:
        return 'grammar/grammar43-02.html'
      case Deformation.VerbtaiForm:
        return 'grammar/grammar17-02.html'
      case Deformation.VerbtariForm:
        return 'grammar/grammar23-01.html'
      case Deformation.VerbnakerebaForm:
        return 'grammar/grammar19-03.html'
      case Deformation.AdjLianYongForm:
        return 'grammar/grammarCommon04.html'
      case Deformation.AdjteForm:
        return 'grammar/grammar16-01.html'
      case Deformation.AdjbaForm:
        return 'grammar/grammar37-01.html'
      case Deformation.AdjJianForm:
        return 'grammar/grammar22-01.html'
      case Deformation.AdjJianFouForm:
        return 'grammar/grammar22-01.html'
      case Deformation.AdjJianGuoForm:
        return 'grammar/grammar22-01.html'
      case Deformation.AdjJianGuoFouForm:
        return 'grammar/grammar22-01.html'
    }
  }
}