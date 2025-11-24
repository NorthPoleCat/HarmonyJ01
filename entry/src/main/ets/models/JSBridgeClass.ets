import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { util, JSON } from '@kit.ArkTS';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { WordModel } from '../models/WordModel';
import { SentenceModel } from './SentenceModel';
import { AudioPlayer } from '../tools/AudioPlayer'

export class JSBridgeClass {
  private controller: webview.WebviewController
  private prefs: preferences.Preferences = preferences.getPreferencesSync(getContext(), { name: 'userSettings' })

  constructor(controller: webview.WebviewController) {
    this.controller = controller
  }

  grammar(param: string) {
    this.controller.loadUrl($rawfile(('grammar/' + param + '.html')))
  }

  sentence(param: string) {
    // const fileName = `${param}.json`
    const lesson: string = param.split('-')[0]
    const fileName = `SentenceJsons/${lesson}/${param}.json`
    let context = getContext(this) as common.UIAbilityContext
    if (context == null) {
      console.error('getContext null')
      return
    }

    context.resourceManager.getRawFileContent(fileName, (err: BusinessError, data) => {
      if (err) {
        console.error('getRawFileContent err: ' + JSON.stringify(err))
        return
      }

      let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
      let decodedData = textDecoder.decodeWithStream(data, { stream: false})
      let jsonString = decodedData.toString()

      try {
        // 进行数据解析
        let record: SentenceModel = JSON.parse(jsonString) as SentenceModel
        // const word = record[index]
        router.pushUrl({
          url: 'pages/SentenceView',
          params: record
        })

      } catch (err) {
        console.error('parse err: ' + JSON.stringify(err))
      }
    })
  }

  word(param: string) {
    const PREFIX_LIST = ['noun-', 'verb-', 'adj-'];
    let prefix = PREFIX_LIST.find(item => param.startsWith(item)) || "";

    const parts: string[] = param.split('-');
    const num: number = parseInt(parts[1])
    const m: number = Math.trunc(num / 100)
    const index: number = num % 100

    let fileName = ''

    if (prefix == 'noun-') {
      fileName = `wordJsons/noun/${prefix}${m}.json`
    } else if (prefix == 'verb-') {
      fileName = `wordJsons/verb/${prefix}${m}.json`
    } else {
      fileName = `wordJsons/adj/${prefix}${m}.json`
    }

    let context = getContext(this) as common.UIAbilityContext
    if (context == null) {
      console.error('getContext null')
      return
    }

    context.resourceManager.getRawFileContent(fileName, (err: BusinessError, data) => {
      if (err) {
        console.error('getRawFileContent err: ' + JSON.stringify(err))
        return
      }

      let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
      let decodedData = textDecoder.decodeWithStream(data, { stream: false})
      let jsonString = decodedData.toString()

      try {
        // 进行数据解析
        let record: Record<string, WordModel> = JSON.parse(jsonString) as Record<string, WordModel>
        const word = record[index]
        router.pushUrl({
          url: 'pages/WordView',
          params: word
        })

      } catch (err) {
        console.error('parse err: ' + JSON.stringify(err))
      }
    })
  }

  audioPlay() {
    let audio = new AudioPlayer()
    audio.playRawAudio('audio/01.mp3')
  }

  loadCss() {
    let nounSet = this.prefs.getSync('nounSet', true)
    let verbSet = this.prefs.getSync('verbSet', true)
    let adjSet = this.prefs.getSync('adjSet', true)
    let chSet = this.prefs.getSync('chSet', true)
    let hiraSet = this.prefs.getSync('hiraSet', true)
    let fontSet = this.prefs.getSync('fontSet', 100)

    let cssArr: Array<string> = []

    if (nounSet) {
      cssArr.push('../StaticFiles/NounWord.css')
    }

    if (verbSet) {
      cssArr.push('../StaticFiles/VerbWord.css')
    }

    if (adjSet) {
      cssArr.push('../StaticFiles/AdjWord.css')
    }

    if (!chSet) {
      cssArr.push('../StaticFiles/NonCh.css')
    }

    if (!hiraSet) {
      cssArr.push('../StaticFiles/NonJia.css')
    }

    let JSResult = `appendCss('${cssArr.join(",")}')`
    this.controller.runJavaScript(JSResult)

    let FontResult = `setFont('${fontSet}')`
    this.controller.runJavaScript(FontResult)
  }
}