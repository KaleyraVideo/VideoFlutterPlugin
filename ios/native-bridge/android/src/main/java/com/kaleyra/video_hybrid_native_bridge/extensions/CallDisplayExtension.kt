// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.Background
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.Foreground
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.ForegroundPictureInPicture

internal fun CallDisplayMode.toSDK() = when (this) {
    Background                 -> CallUI.DisplayMode.Background
    Foreground                 -> CallUI.DisplayMode.Foreground
    ForegroundPictureInPicture -> CallUI.DisplayMode.PictureInPicture
}
