// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * This is used to display the user details in the call/chat UI
 */
export interface UserDetailsFormat {
  /**
   * Format to be used to display a user details on the call/chat UI
   * <br/>
   * <br/>
   * <b><font color="blue">default</font>: ${userAlias}</b>
   */
  default: string;

  /**
   * Format to be used when displaying an android notification
   * <br/>
   * <br/>
   * <b><font color="blue">default</font>: equals to UserDetailsFormatter.default</b>
   */
  androidNotification?: string;
}
