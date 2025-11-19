export class SentenceModel {
  character: string = ''
  translate: string = ''
  Tips: string[] = []
  involvedGrammar: InvolvedGrammarModel[] = []
}

class InvolvedGrammarModel {
  grammarName: string = ''
  grammarNum: string = ''
}