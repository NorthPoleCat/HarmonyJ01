import { preferences } from '@kit.ArkData';
import { router } from '@kit.ArkUI';


@Entry
@Component
struct PrivacyDialogPage {

  private prefs: preferences.Preferences = preferences.getPreferencesSync(getContext(), { name: 'userSettings' })

  aboutToAppear(): void {
    if (this.prefs.getSync('hasAgreedPrivacy', false)) {
      this.navigateToMainPage();
    }
  }

  build() {
    Column() {
      Text('标日笔记系列APP隐私政策')
        .width('100%')
        .fontWeight(FontWeight.Bold)
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)
      Text('标日笔记系列APP由本人（刘逊）为您提供。')
        .width('100%')
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)
      Text('本隐私声明为处理您的个人信息而制定。')
        .width('100%')
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)
      Text('我非常重视您的个人信息和隐私保护，将会按照法律要求和业界成熟的安全标准，为您的个人信息提供相应的安全保护措施。')
        .width('100%')
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)
      Text('标日笔记系列APP为单机应用，不会收集您的任何个人信息，且为所有人开放全量功能服务。')
        .width('100%')
        .fontWeight(FontWeight.Bold)
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)
      Text('如由任何疑问或反馈，欢迎致信 polarcat1991@gmail.com')
        .width('100%')
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)
      Text('或直接私信B站：北极猫1991')
        .width('100%')
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)
      Text('祝您学业有成，功不唐捐。')
        .width('100%')
        .padding({bottom: 12})
        .textAlign(TextAlign.Start)

      Blank()

      Button('了解')
        .onClick(() => {
          this.prefs.putSync('hasAgreedPrivacy', true)
          this.prefs.flush(()=> {
            this.navigateToMainPage()
          })
        })
        .align(Alignment.Center)
        .width(80)
        .height(40)
    }
    .width('100%')
    .height('100%')
    .padding({left: 16, right: 16, top: 16, bottom: 16})
  }

  private navigateToMainPage(): void {
    router.replaceUrl({
      url: 'pages/Index'
    });
  }
}