// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * This enum defines all the events that may be handled
 * <br/>
 * <br/>
 * You can listen to these events via [[BandyerPlugin.on]]
 */
export enum Events {
  /**
   * Used for access token retrieval
   */
  accessTokenRequest = 'accessTokenRequest',
  /**
   * Used to notify setup errors
   */
  setupError = 'setupError',
  /**
   * Used to notify call module status changed
   */
  callModuleStatusChanged = 'callModuleStatusChanged',
  /**
   * Used to notify call errors
   */
  callError = 'callError',
  /**
   * Used to notify chat errors
   */
  chatError = 'chatError',
  /**
   * Used to notify chat module status changed
   */
  chatModuleStatusChanged = 'chatModuleStatusChanged',
  /**
   * Used to notify voip push token updates
   */
  iOSVoipPushTokenUpdated = 'iOSVoipPushTokenUpdated',
  /**
   * Used to notify voip push token invalidation
   */
  iOSVoipPushTokenInvalidated = 'iOSVoipPushTokenInvalidated',
}
