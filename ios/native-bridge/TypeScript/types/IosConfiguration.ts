// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import {CallKitConfiguration} from "./CallKitConfiguration";
import {VoipHandlingStrategy} from "./VoipHandlingStrategy";

/**
 * Configuration for iOS platform
 */
export interface IosConfiguration {

    /**
     * Specify the callkit configuration to enable the usage and it's behaviour
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: enabled</b>
     */
    callkit?: CallKitConfiguration;

    /**
     * Specify the voip handling strategy.
     * <br/>
     * This allows you to disable or leave the plugin behaviour for handling the voip notifications.
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: VoipHandlingStrategy.AUTOMATIC </b>
     */
    voipHandlingStrategy?: VoipHandlingStrategy;
}
