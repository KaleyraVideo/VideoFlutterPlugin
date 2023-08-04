// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import { IosConfiguration } from "./IosConfiguration";
import { Tools } from "./Tools";
import { Environment } from "./Environment";
import { Region } from "./Region";

/**
 * Generic configuration used for setup
 */
export interface KaleyraVideoConfiguration {
  /**
   * This key will be provided to you by us.
   */
  appID: string;

  /**
   * This variable defines the environment where you will be sandbox or production.
   */
  environment: Environment;

  /**
   * This variable defines the region where you will be europe, india or us.
   */
  region: Region;

  /**
   * Set to true to enable log, default value is false
   */
  logEnabled?: boolean;

  /**
   * Define the tools to use
   */
  tools?: Tools;

  /**
   * Define to customize the iOS configuration
   */
  iosConfig?: IosConfiguration;
}
