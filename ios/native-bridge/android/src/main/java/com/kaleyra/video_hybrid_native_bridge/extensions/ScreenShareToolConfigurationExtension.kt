// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.tool_configuration.screen_share.CustomScreenShareConfiguration
import com.bandyer.android_sdk.tool_configuration.screen_share.ScreenShareOptionSet
import com.kaleyra.video_hybrid_native_bridge.ScreenShareToolConfiguration

internal fun ScreenShareToolConfiguration?.toSDK(): ScreenShareOptionSet? = when {
    this?.inApp == true && this.wholeDevice == true -> CustomScreenShareConfiguration.Options(ScreenShareOptionSet.USER_SELECTION)
    this?.inApp == true                             -> CustomScreenShareConfiguration.Options(ScreenShareOptionSet.APP_ONLY)
    this?.wholeDevice == true                       -> CustomScreenShareConfiguration.Options(ScreenShareOptionSet.WHOLE_DEVICE)
    else                                            -> null
}
