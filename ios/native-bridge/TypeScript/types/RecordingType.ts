// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * Recording type of the call
 */
export enum RecordingType {
  /**
   * The call will be recorded on demand
   */
  MANUAL = 'manual',

  /**
   * The call will be recorded as soon it starts
   */
  AUTOMATIC = 'automatic',

  /**
   * The call will not be recorded
   */
  NONE = 'none',
}
