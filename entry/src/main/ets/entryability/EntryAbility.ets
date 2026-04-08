import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';

const DOMAIN = 0x0000;
const PREFERENCE_NAME = 'userSettings'
const PRIVACY_KEY = 'hasAgreedPrivacy'
const PENDING_ROUTE_KEY = 'pendingStartupRoute'

export default class EntryAbility extends UIAbility {
  private startupWant?: Want
  private mainWindowStage?: window.WindowStage

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.startupWant = want
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.startupWant = want
    this.openTargetPageIfNeeded()
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onNewWant');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    this.mainWindowStage = windowStage

    const launchPage = this.getLaunchPage()
    windowStage.loadContent(launchPage, (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    this.mainWindowStage = undefined
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  private getLaunchPage(): string {
    if (!this.hasAgreedPrivacy()) {
      return 'pages/PrivacyDialogPage'
    }

    const targetUrl = this.startupWant?.parameters?.['url']
    if (typeof targetUrl === 'string' && targetUrl.length > 0) {
      this.savePendingRoute(targetUrl)
      return 'pages/Index'
    }

    return 'pages/Index'
  }

  private hasAgreedPrivacy(): boolean {
    const prefs = preferences.getPreferencesSync(this.context, { name: PREFERENCE_NAME })
    return prefs.getSync(PRIVACY_KEY, false) as boolean
  }

  private openTargetPageIfNeeded(): void {
    if (!this.hasAgreedPrivacy()) {
      return
    }

    const targetUrl = this.startupWant?.parameters?.['url']
    if (typeof targetUrl !== 'string' || targetUrl.length === 0) {
      return
    }

    this.savePendingRoute(targetUrl)
    this.mainWindowStage?.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to open target page. Cause: %{public}s', JSON.stringify(err));
      }
    })
  }

  private savePendingRoute(targetUrl: string): void {
    const prefs = preferences.getPreferencesSync(this.context, { name: PREFERENCE_NAME })
    prefs.putSync(PENDING_ROUTE_KEY, targetUrl)
    prefs.flushSync()
  }
}
