import { media } from '@kit.MediaKit'
import common from '@ohos.app.ability.common'
import { BusinessError } from '@kit.BasicServicesKit'
import { audio } from '@kit.AudioKit'

export class AudioPlayer {
  private avPlayer: media.AVPlayer | null = null

  async initAVPlayer() {
    this.avPlayer = await media.createAVPlayer();

    this.avPlayer.on('stateChange', async (state: media.AVPlayerState) => {
      console.info('AVPlayer状态变化:', state);

      switch (state) {
        case 'prepared':
          // this.isPrepared = true;
          console.info('音频准备完成，开始播放');
          await this.avPlayer!.play();
          break;
        case 'playing':
          console.info('音频正在播放');
          break;
        case 'completed':
          console.info('音频播放完成');
          break;
        case 'error':
          console.error('播放器错误状态');
          break;
      }
    });

    // 错误监听
    this.avPlayer.on('error', (error: BusinessError) => {
      console.error('AVPlayer错误:', JSON.stringify(error));
    });
  }

  async playRawAudio(audioFileName: string) {
    if (!this.avPlayer) {
      await this.initAVPlayer();
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

    await this.avPlayer!.prepare();

    // try {
    //   this.avPlayer!.play();
    // } catch (e) {
    //   console.error(`avPlay = ${JSON.stringify(e)}`);
    // }
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
}