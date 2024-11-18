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
   * The user's display name.
   */
  name?: string;

  /**
   * Image url to use as placeholder for the user.
   */
  imageUrl?: string;
}
