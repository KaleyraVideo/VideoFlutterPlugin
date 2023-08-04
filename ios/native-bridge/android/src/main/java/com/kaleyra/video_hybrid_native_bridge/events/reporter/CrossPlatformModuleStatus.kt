// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import com.bandyer.android_sdk.module.BandyerModuleStatus
import com.bandyer.android_sdk.module.BandyerModuleStatus.CONNECTED
import com.bandyer.android_sdk.module.BandyerModuleStatus.CONNECTING
import com.bandyer.android_sdk.module.BandyerModuleStatus.DISCONNECTED
import com.bandyer.android_sdk.module.BandyerModuleStatus.FAILED
import com.bandyer.android_sdk.module.BandyerModuleStatus.READY
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Connecting
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Failed
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Ready
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Stopped

enum class CrossPlatformModuleStatus {
    Ready,
    Connecting,
    Stopped,
    Failed
}

internal fun BandyerModuleStatus.toCrossPlatformModuleStatus(): String = when (this) {
    CONNECTING       -> Connecting.name.lowercase()
    CONNECTED, READY -> Ready.name.lowercase()
    DISCONNECTED     -> Stopped.name.lowercase()
    FAILED           -> Failed.name.lowercase()
}
