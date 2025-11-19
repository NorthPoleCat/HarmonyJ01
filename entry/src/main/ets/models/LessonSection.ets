export class LessonSection {
  title: string = ''
  rows: Array<LessonClass> = []
}

export class LessonClass {
  title: string = '';
  url: string = '';
  vip: boolean = false;

  constructor(title: string, url: string, vip: boolean) {
    this.title = title;
    this.url = url;
    this.vip = vip;
  }
}