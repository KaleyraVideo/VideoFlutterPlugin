// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events

import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CallEventsReporter
import com.kaleyra.video_hybrid_native_bridge.events.reporter.ChatEventsReporter
import com.kaleyra.video_hybrid_native_bridge.events.reporter.ModuleEventsReporter
import com.kaleyra.video_hybrid_native_bridge.events.reporter.SDKEventsReporter
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class SDKEventsReporterTest {

    private val moduleEventsReporter = mockk<ModuleEventsReporter>(relaxed = true)
    private val callEventsReporter = mockk<CallEventsReporter>(relaxed = true)
    private val chatEventsReporter = mockk<ChatEventsReporter>(relaxed = true)

    @Test
    fun startTwiceObserveOnlyOnce() = runTest(CoroutineName("io")) {
        val sdkEventsReporter = SDKEventsReporter(
            moduleEventsReporter = moduleEventsReporter,
            callEventsReporter = callEventsReporter,
            chatEventsReporter = chatEventsReporter,
            scope = this
        )
        advanceUntilIdle()
        sdkEventsReporter.start()
        sdkEventsReporter.start()
        advanceUntilIdle()
        verify(atMost = 1) {
            moduleEventsReporter.start()
            callEventsReporter.start()
            chatEventsReporter.start()
        }
    }

    @Test
    fun stopTwiceRemoveObserveOnlyOnce() = runTest(CoroutineName("io")) {
        val sdkEventsReporter = SDKEventsReporter(
            moduleEventsReporter = moduleEventsReporter,
            callEventsReporter = callEventsReporter,
            chatEventsReporter = chatEventsReporter,
            scope = this
        )
        advanceUntilIdle()
        sdkEventsReporter.start()
        sdkEventsReporter.stop()
        sdkEventsReporter.stop()
        advanceUntilIdle()
        verify(atMost = 1) {
            moduleEventsReporter.stop()
            callEventsReporter.stop()
            chatEventsReporter.stop()
        }
    }

}
