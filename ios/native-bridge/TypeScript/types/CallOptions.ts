// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import {RecordingType} from "./RecordingType";

/**
 * Options available for a call
 */
export interface CallOptions {

    /**
     * May have three different values, NONE, AUTOMATIC, MANUAL
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: none</b>
     */
    recordingType?: RecordingType;
}
