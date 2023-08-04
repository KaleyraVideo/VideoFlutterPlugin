// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_hybrid_native_bridge.Environment
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class EnvironmentTest {

    @Test
    fun sandbox() {
        val env = Environment("sandbox")
        assertEquals(com.kaleyra.collaboration_suite_networking.Environment.Sandbox, env.toSDK())
    }

    @Test
    fun production() {
        val env = Environment("production")
        assertEquals(com.kaleyra.collaboration_suite_networking.Environment.Production, env.toSDK())
    }

    @Test
    fun custom() {
        val env = Environment("custom")
        assertEquals(com.kaleyra.collaboration_suite_networking.Environment.create("custom"), env.toSDK())
    }
}
