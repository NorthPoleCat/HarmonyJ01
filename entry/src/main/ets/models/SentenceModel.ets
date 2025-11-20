export class SentenceModel {
  character: string = ''
  translate: string = ''
  Tips: string[] = []
  involvedGrammar: InvolvedGrammarModel[] = []
}

export class InvolvedGrammarModel {
  grammarName: string = ''
  grammarNum: string = ''
}