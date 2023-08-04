// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import {CallOptions} from "./CallOptions";
import {AudioCallOptions} from "./AudioCallOptions";

/**
 * Chat tool configuration
 */
export interface ChatToolConfiguration {

    /**
     * Defining this object will enable an option to start an audio call from chat UI
     */
    audioCallOption?: AudioCallOptions;

    /**
     * Defining this object will enable an option to start an audio&video call from chat UI
     */
    videoCallOption?: CallOptions;
}
