// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * This class defines the types of calls supported.
 */
export enum CallType {
  /**
   * Audio only is a call that will only use the microphone
   */
  AUDIO = 'audio',

  /**
   * Audio Upgradable is a call a type of call that starts in audio only and may be upgraded to audio&video type
   */
  AUDIO_UPGRADABLE = 'audioUpgradable',

  /**
   * Audio Video is a call that will use both the camera and the microphone
   */
  AUDIO_VIDEO = 'audioVideo',
}
