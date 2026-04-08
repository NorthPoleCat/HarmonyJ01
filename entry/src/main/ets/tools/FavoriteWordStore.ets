import { preferences } from '@kit.ArkData'
import { JSON } from '@kit.ArkTS'
import common from '@ohos.app.ability.common'
import { WordModel } from '../models/WordModel'

export class FavoriteWordStore {
  private static readonly FAVORITE_KEY: string = 'favoriteWords'
  private static readonly PREFERENCE_NAME: string = 'userSettings'

  private static getPreferences(context: common.Context): preferences.Preferences {
    return preferences.getPreferencesSync(context, { name: FavoriteWordStore.PREFERENCE_NAME })
  }

  private static favoriteId(word: WordModel): string {
    return `${word.character}|${word.rome ?? ''}|${word.translate ?? ''}`
  }

  private static toWordModel(item: WordModel): WordModel {
    const word = new WordModel()
    word.character = item.character ?? ''
    word.partOfSpeech = item.partOfSpeech
    word.isAutoVerb = item.isAutoVerb
    word.isAdv = item.isAdv
    word.rome = item.rome
    word.translate = item.translate
    return word
  }

  private static save(context: common.Context, words: Array<WordModel>): void {
    const prefs = FavoriteWordStore.getPreferences(context)
    prefs.putSync(FavoriteWordStore.FAVORITE_KEY, JSON.stringify(words))
    prefs.flushSync()
  }

  static list(context: common.Context): Array<WordModel> {
    const prefs = FavoriteWordStore.getPreferences(context)
    const content = prefs.getSync(FavoriteWordStore.FAVORITE_KEY, '[]') as string

    try {
      const records = JSON.parse(content) as Array<WordModel>
      if (!Array.isArray(records)) {
        return []
      }
      return records.map((item: WordModel) => FavoriteWordStore.toWordModel(item))
    } catch (_err) {
      return []
    }
  }

  static isFavorite(context: common.Context, word: WordModel): boolean {
    const favoriteId = FavoriteWordStore.favoriteId(word)
    return FavoriteWordStore.list(context).some((item: WordModel) => {
      return FavoriteWordStore.favoriteId(item) === favoriteId
    })
  }

  static add(context: common.Context, word: WordModel): void {
    const words = FavoriteWordStore.list(context)
    const favoriteId = FavoriteWordStore.favoriteId(word)
    if (words.some((item: WordModel) => FavoriteWordStore.favoriteId(item) === favoriteId)) {
      return
    }

    words.unshift(FavoriteWordStore.toWordModel(word))
    FavoriteWordStore.save(context, words)
  }

  static remove(context: common.Context, word: WordModel): void {
    const favoriteId = FavoriteWordStore.favoriteId(word)
    const words = FavoriteWordStore.list(context).filter((item: WordModel) => {
      return FavoriteWordStore.favoriteId(item) !== favoriteId
    })
    FavoriteWordStore.save(context, words)
  }

  static toggle(context: common.Context, word: WordModel): boolean {
    if (FavoriteWordStore.isFavorite(context, word)) {
      FavoriteWordStore.remove(context, word)
      return false
    }

    FavoriteWordStore.add(context, word)
    return true
  }
}
