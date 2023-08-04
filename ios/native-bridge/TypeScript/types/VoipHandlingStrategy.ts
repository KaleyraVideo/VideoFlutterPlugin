// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * This class defines the voip notification strategy per call.
 */
export enum VoipHandlingStrategy {
  /**
   * The voip notifications will not be handled
   */
  DISABLED = 'disabled',

  /**
   * The voip notifications will be handled automatically from the plugin
   */
  AUTOMATIC = 'automatic',
}
