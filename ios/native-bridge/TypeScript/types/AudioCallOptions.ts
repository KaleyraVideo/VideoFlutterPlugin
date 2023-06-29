// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import {CallOptions} from "./CallOptions";
import {AudioCallType} from "./AudioCallType";

/**
 * Audio call options used for chat
 */
export interface AudioCallOptions extends CallOptions {
    /**
     * Type of audioCall to launch when an option of the chat is tapped.
     */
    type: AudioCallType;
}
