// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_common_ui.CallUI
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
        assertEquals(CallUI.Action.ScreenShare.App, screenShareToolConfiguration.toSDK()!!)
    }

    @Test
    fun wholeDevice() {
        val screenShareToolConfiguration = ScreenShareToolConfiguration(wholeDevice = true)
        assertEquals(CallUI.Action.ScreenShare.WholeDevice, screenShareToolConfiguration.toSDK()!!)
    }

    @Test
    fun both() {
        val screenShareToolConfiguration = ScreenShareToolConfiguration(inApp = true, wholeDevice = true)
        assertEquals(CallUI.Action.ScreenShare.UserChoice, screenShareToolConfiguration.toSDK()!!)
    }
}
