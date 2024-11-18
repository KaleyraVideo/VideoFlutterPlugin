// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video.conference.Call
import com.kaleyra.video_hybrid_native_bridge.RecordingType

internal fun RecordingType?.toSDK() = when (this) {
    RecordingType.Manual    -> Call.Recording.manual()
    RecordingType.Automatic -> Call.Recording.automatic()
    else                    -> Call.Recording.disabled()
}
