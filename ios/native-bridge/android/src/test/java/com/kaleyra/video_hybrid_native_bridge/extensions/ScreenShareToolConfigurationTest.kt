// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.tool_configuration.screen_share.ScreenShareOptionSet
import com.kaleyra.video_hybrid_native_bridge.ScreenShareToolConfiguration
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class ScreenShareToolConfigurationTest {

    @Test
    fun none() {
        val screenShareToolConfiguration = ScreenShareToolConfiguration()
        assertEquals(null, screenShareToolConfiguration.toSDK())
    }

    @Test
    fun inApp() {
        val screenShareToolConfiguration = ScreenShareToolConfiguration(inApp = true)
        assertEquals(ScreenShareOptionSet.APP_ONLY, screenShareToolConfiguration.toSDK()!!.mode)
    }

    @Test
    fun wholeDevice() {
        val screenShareToolConfiguration = ScreenShareToolConfiguration(wholeDevice = true)
        assertEquals(ScreenShareOptionSet.WHOLE_DEVICE, screenShareToolConfiguration.toSDK()!!.mode)
    }

    @Test
    fun both() {
        val screenShareToolConfiguration = ScreenShareToolConfiguration(inApp = true, wholeDevice = true)
        assertEquals(ScreenShareOptionSet.USER_SELECTION, screenShareToolConfiguration.toSDK()!!.mode)
    }
}
