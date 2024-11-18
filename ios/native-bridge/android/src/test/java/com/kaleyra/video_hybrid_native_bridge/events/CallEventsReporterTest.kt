// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events

import com.kaleyra.video.conference.Call
import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_common_ui.ConferenceUI
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CallEventsReporter
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.job
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class CallEventsReporterTest {

    private val conference = mockk<ConferenceUI>(relaxed = true)
    private val sdk = mockk<KaleyraVideo>(relaxed = true) {
        every { conference } returns this@CallEventsReporterTest.conference
    }

    private val eventsEmitter = mockk<EventsEmitter>(relaxed = true)
    private val mockCall = mockk<CallUI> {
        every { id } returns "callID"
    }

    @Test
    fun testStart() = runTest {
        every { conference.call } returns MutableStateFlow(mockCall)
        val callEventsReporter = CallEventsReporter(sdk, eventsEmitter, backgroundScope)
        callEventsReporter.start()
        assertEquals(1, backgroundScope.coroutineContext.job.children.count { it.isActive })
    }

    @Test
    fun testMultipleStartOnlyOneJob() = runTest {
        every { conference.call } returns MutableStateFlow(mockCall)
        val callEventsReporter = CallEventsReporter(sdk, eventsEmitter, backgroundScope)
        callEventsReporter.start()
        callEventsReporter.start()
        assertEquals(true, backgroundScope.coroutineContext.job.children.find { it.isCancelled } != null)
        assertEquals(true, backgroundScope.coroutineContext.job.children.find { it.isActive } != null)
    }

    @Test
    fun testStop() = runTest {
        every { conference.call } returns MutableStateFlow(mockCall)
        val callEventsReporter = CallEventsReporter(sdk, eventsEmitter, backgroundScope)
        callEventsReporter.start()
        callEventsReporter.stop()
        assertEquals(true, backgroundScope.coroutineContext.job.children.find { it.isCancelled } != null)
    }

    @Test
    fun onCallEndedWithErrorSendEvent() = runTest(UnconfinedTestDispatcher()) {
        every { conference.call } returns MutableStateFlow(mockCall)
        every { mockCall.state } returns MutableStateFlow(Call.State.Disconnected.Ended.Error.Companion)
        val callEventsReporter = CallEventsReporter(sdk, eventsEmitter, backgroundScope)
        callEventsReporter.start()
        verify {
            eventsEmitter.sendEvent(Events.CallError, "An error has occurred")
        }
    }
}
