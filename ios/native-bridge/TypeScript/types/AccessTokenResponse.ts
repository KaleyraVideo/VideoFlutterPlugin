// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * @ignore
 */
export class AccessTokenResponse {
  constructor(
    requestID: string,
    success: boolean,
    data: string,
    error: string
  ) {
    this.requestID = requestID;
    this.success = success;
    this.data = data;
    this.error = error;
  }

  static failed(requestID: string, reason?: string): AccessTokenResponse {
    return {
      requestID,
      success: false,
      data: '',
      error: reason,
    };
  }

  static success(requestID: string, token: string): AccessTokenResponse {
    return {
      requestID,
      success: true,
      data: token,
    };
  }

  requestID: string;
  success: boolean;
  data: string;
  error?: string;
}
