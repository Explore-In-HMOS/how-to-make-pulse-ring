import { AnimatorResult, AnimatorOptions } from '@kit.ArkUI'

const MIN = 84
const MAX = 140

interface ThemeConf {
  bg: Color
  fg: Color
  ring: Color
  border: number
}

const THEMES: ThemeConf[] = [
  { bg: Color.Black, fg: Color.White, ring: Color.White, border: 3 },
  { bg: Color.White, fg: Color.Black, ring: Color.Black, border: 3 },
  { bg: Color.Gray,  fg: Color.Black, ring: Color.White, border: 4 },
]


const RING_PALETTE: Color[] = [
  Color.White, Color.Black, Color.Red, Color.Green, Color.Blue, Color.Yellow
]

@Entry
@Component
struct Index {
  @State running: boolean = false
  @State progress: number = 0
  @State themeIdx: number = 0
  @State ringColor: Color | null = null

  private anim?: AnimatorResult

  aboutToDisappear() {
    if (this.anim) {
      try { this.anim.cancel() } catch (_) {}
      this.anim = undefined
    }
  }

  private ensureAnimator() {
    if (this.anim) return
    const opts: AnimatorOptions = {
      duration: 1800,
      easing: 'smooth',
      delay: 0,
      fill: 'forwards',
      direction: 'alternate',
      iterations: -1,
      begin: 0,
      end: 1
    }
    this.anim = this.getUIContext().createAnimator(opts)
    this.anim.onFrame = (v: number) => { this.progress = v }
    this.anim.onFinish = () => { this.running = false }
    this.anim.onCancel = () => { this.running = false }
  }

  private playPause() {
    this.ensureAnimator()
    if (this.running) {
      this.anim!.pause()
      this.running = false
    } else {
      this.anim!.play()
      this.running = true
    }
  }


  private ringSize(): number {
    return MIN + (MAX - MIN) * this.progress
  }

  private theme(): ThemeConf {
    return THEMES[this.themeIdx % THEMES.length]
  }

  private currentRingColor(): Color {
    return this.ringColor ?? this.theme().ring
  }

  private nextTheme() {
    this.themeIdx = (this.themeIdx + 1) % THEMES.length

  }

  build() {
    Column() {
      Text(this.running ? 'Running' : 'Paused')
        .fontSize(12)
        .fontColor(this.theme().fg)
        .margin({ bottom: 6 })


      Stack() {
        if (!this.running) {
          Text('Tap')
            .fontSize(14)
            .fontColor(this.theme().fg)
        }
      }
      .width(this.ringSize())
      .height(this.ringSize())
      .border({
        width: this.theme().border,
        color: this.currentRingColor(),
        radius: this.ringSize() / 2
      })
      .backgroundColor(this.theme().bg)
      .alignSelf(ItemAlign.Center)
      .gesture(TapGesture().onAction(() => this.playPause()))
      .margin({ bottom: 10 })

      Row() {
        ForEach(
          RING_PALETTE,
          (c: Color, idx: number) => {
            Stack()
              .width(18).height(18)
              .border({ width: 1, color: this.theme().fg, radius: 9 })
              .backgroundColor(c)
              .margin({ left: 4, right: 4 })
              .gesture(TapGesture().onAction(() => { this.ringColor = c }))
          },

          (c: Color, idx: number) => idx.toString()
        )
      }
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 8 })


      Button('Theme')
        .height(28)
        .width(70)
        .onClick(() => this.nextTheme())
        .backgroundColor(this.currentRingColor())
        .alignSelf(ItemAlign.Center)
    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(8)
    .backgroundColor(this.theme().bg)
  }
}
