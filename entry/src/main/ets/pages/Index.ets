import rawData from '../../resources/rawfile/allLessons.json';
import { LessonSection, LessonClass } from '../models/LessonSection';
import { router } from '@kit.ArkUI';

interface DataProps {
  sections: LessonSection[];
}

function parseSections(data: DataProps): Array<LessonSection> {
  return data.sections.map((section: LessonSection) => {
    const lessonSection = new LessonSection();
    lessonSection.title = section.title;
    lessonSection.rows = section.rows.map((row: LessonClass) =>
    new LessonClass(row.title, row.url, row.vip)
    );
    return lessonSection;
  });
}

@Entry
@Component
struct Index {
  private sections: LessonSection[] = []

  aboutToAppear() {
    this.sections = parseSections(rawData)
  }

  @Builder
  itemHeader(text: string) {
    Text(text)
      .fontSize(16)
      .fontColor(0xe5aa5a)
      .backgroundColor(0xececec)
      .width('100%')
      .padding(10)
  }

  build() {
    Column() {
      Text('新版标准日本语-初级')
        .fontSize(20)
        .fontColor(Color.White)
        .backgroundColor(0xe5aa5a)
        .width('100%')
        .textAlign(TextAlign.Center)
        .height(44)

      List({ space: 12 }) {
        ForEach(this.sections, (section: LessonSection) => {
          ListItemGroup({ header: this.itemHeader(section.title) }) {
            ForEach(section.rows, (row: LessonClass, index) => {
              ListItem() {
                Column() {
                  Text(row.title)
                    .fontSize(16)
                    .padding(10)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .backgroundColor(Color.White)
                  if (index !== section.rows.length - 1) {
                    Divider()
                      .strokeWidth(1)
                      .color(0xececec)
                      .margin({ left: 10, right: 10 })
                  }
                }
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebViewPage', // 目标页面路径
                  params: { url: 'Lessons/' + row.url + '.html', title: row.url }  // 传递 LessonClass 的 URL
                })
              })
              .borderRadius(8)
              .margin({ top: 5, bottom: 5 })
            })
          }
        }, (item: LessonSection) => item.title)
      }
      // .sticky(StickyStyle.Header) // 标题吸顶效果
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .padding({ bottom: 30 })
  }
}