// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * This class defines the types of audio calls supported.
 */
export enum AudioCallType {
  /**
   * Audio only is a call that will only use the microphone
   */
  AUDIO = 'audio',

  /**
   * Audio Upgradable is a call a type of call that starts in audio only and may be upgraded to audio&video type
   */
  AUDIO_UPGRADABLE = 'audioUpgradable',
}
