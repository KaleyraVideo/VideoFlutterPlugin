// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import { CallType } from './CallType';
import { CallOptions } from './CallOptions';

/**
 * Options to be used when creating a call
 */
export interface CreateCallOptions extends CallOptions {
  /**
   * Array of callees identifiers to call.
   */
  callees: string[];

  /**
   * Type of call to create
   */
  callType: CallType;
}
