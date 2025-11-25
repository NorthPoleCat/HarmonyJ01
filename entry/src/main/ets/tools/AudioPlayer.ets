import { media } from '@kit.MediaKit'
import common from '@ohos.app.ability.common'
import { BusinessError } from '@kit.BasicServicesKit'

export class AudioPlayer {
  private avPlayer: media.AVPlayer | null = null
  private isPausing: boolean = false

  start: number = 0
  end: number = 0

  private static instance: AudioPlayer

  public static getInstance(): AudioPlayer {
    if (!AudioPlayer.instance) {
      AudioPlayer.instance = new AudioPlayer();
    }
    return AudioPlayer.instance;
  }

  async initAVPlayer() {
    this.avPlayer = await media.createAVPlayer();

    this.avPlayer.on('stateChange', async (state, reason) => {
      console.info('AVPlayer状态变化:', state);

      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('音频idle');
          break;
        case 'initialized':
          this.avPlayer?.prepare()
          break;
        case 'prepared':
          console.info('音频准备完成，开始播放');
          this.avPlayer?.seek(this.start * 1000)
          break;
        case 'playing':
          console.info('音频正在播放');
          break;
        case 'paused':
          this.isPausing = true
          break;
        case 'completed':
          console.info('音频播放完成');
          this.release()
          break;
        case 'error':
          console.error('播放器错误状态');
          break;
      }
    });

    this.avPlayer.on('seekDone', (seekDoneTime) => {
      this.avPlayer?.play()
    })

    this.avPlayer.on('timeUpdate', (currentTime: number) => {
      // 检查是否到达片段结束位置
      if (currentTime >= this.end * 1000) {
        console.info('⏹️ 到达片段结束位置，停止播放');
        this.stop();
      }
    });

    // 错误监听
    this.avPlayer.on('error', (error: BusinessError) => {
      console.error('AVPlayer错误:', JSON.stringify(error));
    });
  }

  async playRawAudio(audioFileName: string, isAudio: boolean) {
    if (!this.avPlayer) {
      await this.initAVPlayer();
    }

    if (this.avPlayer?.state == 'playing' && isAudio) {
      this.avPause()
      return
    }

    if (this.isPausing) {
      this.avPlayer?.play()
      this.isPausing = false
      return
    }

    let context = getContext(this) as common.UIAbilityContext
    if (context == null) {
      console.error('getContext null')
      return
    }

    let fileDescriptor = await context.resourceManager.getRawFd(audioFileName)
    let avFileDescriptor: media.AVFileDescriptor =
      { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length }
    this.avPlayer!.fdSrc = avFileDescriptor
  }

  avPause(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.pause();
      } catch (e) {
        console.error(`avPause== ${JSON.stringify(e)}`);
      }
    }
  }

  async stop(): Promise<void> {
    if (this.avPlayer) {
      await this.avPlayer.stop();
      this.release()
    }
  }

  release() {
    // 1. 释放音频播放器
    if (this.avPlayer) {
      this.avPlayer.release(); // 调用鸿蒙SDK的释放方法
      this.avPlayer = null;
    }
  }
}