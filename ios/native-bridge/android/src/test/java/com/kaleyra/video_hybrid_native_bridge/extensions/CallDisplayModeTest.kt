// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.Background
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.Foreground
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.ForegroundPictureInPicture
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class CallDisplayModeTest {

    @Test
    fun background() {
        val mode = Background
        assertEquals(com.bandyer.android_sdk.intent.call.CallDisplayMode.BACKGROUND, mode.toSDK())
    }

    @Test
    fun foreground() {
        val mode = Foreground
        assertEquals(com.bandyer.android_sdk.intent.call.CallDisplayMode.FOREGROUND, mode.toSDK())
    }

    @Test
    fun pip() {
        val mode = ForegroundPictureInPicture
        assertEquals(com.bandyer.android_sdk.intent.call.CallDisplayMode.FOREGROUND_PICTURE_IN_PICTURE, mode.toSDK())
    }
}
