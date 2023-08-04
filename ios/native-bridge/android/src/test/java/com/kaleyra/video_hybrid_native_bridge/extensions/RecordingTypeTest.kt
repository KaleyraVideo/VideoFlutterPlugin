// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.intent.call.CallRecordingType
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Automatic
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Manual
import com.kaleyra.video_hybrid_native_bridge.RecordingType.None
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class RecordingTypeTest {

    @Test
    fun default(){
        val type = None
        assertEquals(CallRecordingType.NONE, type.toSDK())
    }

    @Test
    fun manual(){
        val type = Manual
        assertEquals(CallRecordingType.MANUAL, type.toSDK())
    }

    @Test
    fun automatic(){
        val type = Automatic
        assertEquals(CallRecordingType.AUTOMATIC, type.toSDK())
    }

}
