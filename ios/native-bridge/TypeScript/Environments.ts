// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import type { Environment } from './types/Environment';

/**
 * Available environments
 */
export class Environments implements Environment {
  /**
   * Sandbox environment
   */
  static sandbox(): Environment {
    return new Environments('sandbox');
  }

  /**
   * Production environment
   */
  static production(): Environment {
    return new Environments('production');
  }

  /**
   * Create environment by name
   * @param name name of the environment
   */
  static new(name: string): Environment {
    return new Environments(name);
  }

  /**
   * name of the environment
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
