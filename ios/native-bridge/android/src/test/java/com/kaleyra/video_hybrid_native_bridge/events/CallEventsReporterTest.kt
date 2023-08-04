// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events

import com.bandyer.android_sdk.call.CallException
import com.bandyer.android_sdk.call.CallModule
import com.bandyer.android_sdk.client.BandyerSDK
import com.bandyer.android_sdk.intent.call.Call
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CallEventsReporter
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class CallEventsReporterTest {

    private val callModule = mockk<CallModule>(relaxed = true)
    private val sdk = mockk<BandyerSDK>(relaxed = true) {
        every { callModule } returns this@CallEventsReporterTest.callModule
    }

    private val eventsEmitter = mockk<EventsEmitter>(relaxed = true)
    private val callEventsReporter = CallEventsReporter(sdk, eventsEmitter)
    private val mockCall = mockk<Call> {
        every { callInfo } returns mockk {
            every { callId } returns "callID"
        }
    }

    @Test
    fun onStartAddObserver() {
        callEventsReporter.start()
        verify {
            callModule.addCallObserver(callEventsReporter)
            callModule.addCallUIObserver(callEventsReporter)
        }
    }

    @Test
    fun onStopRemoveObserver() {
        callEventsReporter.stop()
        verify {
            callModule.removeCallObserver(callEventsReporter)
            callModule.removeCallUIObserver(callEventsReporter)
        }
    }

    @Test
    fun onCallEndedWithErrorSendEvent() {
        callEventsReporter.onCallEndedWithError(mockCall, CallException("error"))
        verify {
            eventsEmitter.sendEvent(Events.CallError, "error")
        }
    }

    @Test
    fun onCallActivityEndedWithErrorSendEvent() {
        callEventsReporter.onActivityError(mockCall, mockk(), CallException("error"))
        verify {
            eventsEmitter.sendEvent(Events.CallError, "error")
        }
    }

    @Test
    fun onCallEndedWithErrorAndActivityEndedWithErrorSendEventOnce() {
        callEventsReporter.onCallEndedWithError(mockCall, CallException("error"))
        callEventsReporter.onActivityError(mockCall, mockk(), CallException("error"))
        verify(atMost = 1) {
            eventsEmitter.sendEvent(Events.CallError, "error")
        }
    }
}
