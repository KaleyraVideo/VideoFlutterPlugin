// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import type { Region } from './types/Region';

/**
 * Available regions
 */
export class Regions implements Region {
  /**
   * India region
   */
  static india(): Region {
    return new Regions('india');
  }

  /**
   * Europe region
   */
  static europe(): Region {
    return new Regions('europe');
  }

  /**
   * Us region
   */
  static us(): Region {
    return new Regions('us');
  }

  /**
   * Create region by name
   * @param name name of the region
   */
  static new(name: string): Region {
    return new Regions(name);
  }

  /**
   * name of the region
   * @ignore
   */
  name: string;

  /**
   * @ignore
   */
  private constructor(name: string) {
    this.name = name;
  }
}
