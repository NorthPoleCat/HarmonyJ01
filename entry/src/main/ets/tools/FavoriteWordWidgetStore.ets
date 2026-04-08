import { preferences } from '@kit.ArkData'
import common from '@ohos.app.ability.common'
import { FavoriteWordStore } from './FavoriteWordStore'
import { WordModel } from '../models/WordModel'

export interface FavoriteWordWidgetFormData {
  character: string
  rome: string
  meaning: string
  positionText: string
  empty: boolean
  canGoPrev: boolean
  canGoNext: boolean
}

export class FavoriteWordWidgetStore {
  private static readonly PREFERENCE_NAME: string = 'userSettings'
  private static readonly FORM_INDEX_KEY_PREFIX: string = 'favoriteWordWidgetIndex_'

  private static getPreferences(context: common.Context): preferences.Preferences {
    return preferences.getPreferencesSync(context, { name: FavoriteWordWidgetStore.PREFERENCE_NAME })
  }

  private static getIndexKey(formId: string): string {
    return `${FavoriteWordWidgetStore.FORM_INDEX_KEY_PREFIX}${formId}`
  }

  private static clampIndex(words: Array<WordModel>, index: number): number {
    if (words.length === 0) {
      return 0
    }
    if (index < 0) {
      return 0
    }
    if (index >= words.length) {
      return words.length - 1
    }
    return index
  }

  private static getSavedIndex(context: common.Context, formId: string): number {
    const prefs = FavoriteWordWidgetStore.getPreferences(context)
    return prefs.getSync(FavoriteWordWidgetStore.getIndexKey(formId), 0) as number
  }

  private static saveIndex(context: common.Context, formId: string, index: number): void {
    const prefs = FavoriteWordWidgetStore.getPreferences(context)
    prefs.putSync(FavoriteWordWidgetStore.getIndexKey(formId), index)
    prefs.flushSync()
  }

  static removeFormState(context: common.Context, formId: string): void {
    const prefs = FavoriteWordWidgetStore.getPreferences(context)
    prefs.deleteSync(FavoriteWordWidgetStore.getIndexKey(formId))
    prefs.flushSync()
  }

  static currentData(context: common.Context, formId: string): FavoriteWordWidgetFormData {
    const words = FavoriteWordStore.list(context)
    const currentIndex = FavoriteWordWidgetStore.clampIndex(
      words,
      FavoriteWordWidgetStore.getSavedIndex(context, formId)
    )

    FavoriteWordWidgetStore.saveIndex(context, formId, currentIndex)
    return FavoriteWordWidgetStore.toFormData(words, currentIndex)
  }

  static move(context: common.Context, formId: string, step: number): FavoriteWordWidgetFormData {
    const words = FavoriteWordStore.list(context)
    const nextIndex = FavoriteWordWidgetStore.clampIndex(
      words,
      FavoriteWordWidgetStore.getSavedIndex(context, formId) + step
    )

    FavoriteWordWidgetStore.saveIndex(context, formId, nextIndex)
    return FavoriteWordWidgetStore.toFormData(words, nextIndex)
  }

  private static toFormData(words: Array<WordModel>, index: number): FavoriteWordWidgetFormData {
    if (words.length === 0) {
      return {
        character: '暂无收藏',
        rome: '去应用里收藏一些单词吧',
        meaning: '添加收藏后，就能在桌面快速切换查看。',
        positionText: '0 / 0',
        empty: true,
        canGoPrev: false,
        canGoNext: false
      }
    }

    const currentIndex = FavoriteWordWidgetStore.clampIndex(words, index)
    const word = words[currentIndex]
    return {
      character: word.character,
      rome: word.rome ?? '',
      meaning: word.translate ?? '',
      positionText: `${currentIndex + 1} / ${words.length}`,
      empty: false,
      canGoPrev: currentIndex > 0,
      canGoNext: currentIndex < words.length - 1
    }
  }
}
