// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.Region
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class RegionTest {

    @Test
    fun europe() {
        val region = Region("europe")
        assertEquals(com.kaleyra.collaboration_suite_networking.Region.Eu, region.toSDK())
    }

    @Test
    fun india() {
        val region = Region("india")
        assertEquals(com.kaleyra.collaboration_suite_networking.Region.In, region.toSDK())
    }

    @Test
    fun us() {
        val region = Region("us")
        assertEquals(com.kaleyra.collaboration_suite_networking.Region.Us, region.toSDK())
    }

    @Test
    fun custom() {
        val region = Region("custom")
        assertEquals(com.kaleyra.collaboration_suite_networking.Region.create("custom"), region.toSDK())
    }
}
