package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video.conference.Call
import com.kaleyra.video_hybrid_native_bridge.CallType

internal fun CallType.toSDK(): Call.PreferredType {
    return when(this) {
        CallType.Audio -> Call.PreferredType.audioOnly()
        CallType.AudioUpgradable -> Call.PreferredType.audioUpgradable()
        CallType.AudioVideo -> Call.PreferredType.audioVideo()
    }
}