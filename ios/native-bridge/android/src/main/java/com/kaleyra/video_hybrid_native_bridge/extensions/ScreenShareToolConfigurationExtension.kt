// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_hybrid_native_bridge.ScreenShareToolConfiguration

internal fun ScreenShareToolConfiguration?.toSDK(): CallUI.Action.ScreenShare? = when {
    this?.inApp == true && this.wholeDevice == true -> CallUI.Action.ScreenShare.UserChoice
    this?.inApp == true                             -> CallUI.Action.ScreenShare.App
    this?.wholeDevice == true                       -> CallUI.Action.ScreenShare.WholeDevice
    else                                            -> null
}
