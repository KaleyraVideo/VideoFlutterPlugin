// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.intent.call.CallRecordingType
import com.bandyer.android_sdk.intent.call.CallRecordingType.AUTOMATIC
import com.bandyer.android_sdk.intent.call.CallRecordingType.MANUAL
import com.kaleyra.video_hybrid_native_bridge.RecordingType

internal fun RecordingType?.toSDK(): CallRecordingType = when (this) {
    RecordingType.Manual    -> MANUAL
    RecordingType.Automatic -> AUTOMATIC
    else                    -> CallRecordingType.NONE
}
