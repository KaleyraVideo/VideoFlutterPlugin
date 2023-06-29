// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * Session
 */
export interface Session {
  /**
   * The user id you want to connect
   */
  userID: string;

  /**
   * The Kaleyra Video SDK adopts a strong authentication mechanism based on JWT access tokens.
   * Whenever the SDK needs an access token for a particular user, this component will be asked to provide an access token for a particular user.
   * @param userId the user which requires a token refresh
   * @returns a promise containing the access token if completed successfully.
   */
  accessTokenProvider(userId: string): Promise<string>;
}
