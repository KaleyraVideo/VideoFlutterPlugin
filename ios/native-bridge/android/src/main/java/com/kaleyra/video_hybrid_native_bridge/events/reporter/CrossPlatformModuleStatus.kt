// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import com.kaleyra.video.State
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Connecting
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Failed
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Disconnected
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Connected
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Reconnecting

enum class CrossPlatformModuleStatus {
    Disconnected,
    Connecting,
    Connected,
    Reconnecting,
    Failed
}

internal fun State.toCrossPlatformModuleStatus(previousState: State?): String? = when {
    previousState is State.Connected && this is State.Connecting -> Reconnecting.name.lowercase()
    this is State.Connecting         -> Connecting.name.lowercase()
    this is State.Connected          -> Connected.name.lowercase()
    this is State.Disconnected.Error -> Failed.name.lowercase()
    this is State.Disconnected       -> Disconnected.name.lowercase()
    else -> null
}
