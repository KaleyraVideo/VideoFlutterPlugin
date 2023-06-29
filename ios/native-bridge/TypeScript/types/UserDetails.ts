// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * This is used to define the user details in the call/chat UI
 */
export interface UserDetails {
  /**
   * User identifier
   */
  userID: string;

  /**
   * Nickname for the user
   */
  nickName?: string;

  /**
   * First name of the user
   */
  firstName?: string;

  /**
   * Last name of the user
   */
  lastName?: string;

  /**
   * Email of the user
   */
  email?: string;

  /**
   * Image url to use as placeholder for the user.
   */
  profileImageUrl?: string;
}
