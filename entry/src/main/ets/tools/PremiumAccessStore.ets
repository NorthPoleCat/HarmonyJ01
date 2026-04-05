import { preferences } from '@kit.ArkData'
import common from '@ohos.app.ability.common'

export class PremiumAccessStore {
  private static readonly PREFERENCE_NAME: string = 'userSettings'
  private static readonly UNLOCKED_KEY: string = 'premiumUnlocked'

  private static getPreferences(context: common.UIAbilityContext): preferences.Preferences {
    return preferences.getPreferencesSync(context, { name: PremiumAccessStore.PREFERENCE_NAME })
  }

  static isUnlocked(context: common.UIAbilityContext): boolean {
    const prefs = PremiumAccessStore.getPreferences(context)
    return prefs.getSync(PremiumAccessStore.UNLOCKED_KEY, false) as boolean
  }

  static unlock(context: common.UIAbilityContext): void {
    const prefs = PremiumAccessStore.getPreferences(context)
    prefs.putSync(PremiumAccessStore.UNLOCKED_KEY, true)
    prefs.flushSync()
  }

  static requiresUnlock(url: string): boolean {
    const lessonMatch = url.match(/^Lessons\/Lesson(\d+)\.html$/)
    if (lessonMatch) {
      return Number(lessonMatch[1]) >= 25
    }

    const unitMatch = url.match(/^Lessons\/Unit(\d+)\.html$/)
    if (unitMatch) {
      return Number(unitMatch[1]) >= 7
    }

    return false
  }
}
