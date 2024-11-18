// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events

import com.kaleyra.video.State
import com.kaleyra.video_common_ui.ConferenceUI
import com.kaleyra.video_common_ui.ConversationUI
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus
import com.kaleyra.video_hybrid_native_bridge.events.reporter.ModuleEventsReporter
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.job
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RandomRunner::class)
class ModuleEventsReporterTest {

    private val conferenceState = MutableStateFlow<State>(State.Disconnected)
    private val conversationState = MutableStateFlow<State>(State.Disconnected)
    private val conference = mockk<ConferenceUI>(relaxed = true) {
        every { state } returns conferenceState
    }
    private val conversation = mockk<ConversationUI>(relaxed = true) {
        every { state } returns conversationState
    }
    private val sdk = mockk<KaleyraVideo>(relaxed = true) {
        every { conference } returns this@ModuleEventsReporterTest.conference
        every { conversation } returns this@ModuleEventsReporterTest.conversation
    }
    private val eventsEmitter = mockk<EventsEmitter>(relaxed = true)

    @Test
    fun testStart() = runTest {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        assertEquals(2, backgroundScope.coroutineContext.job.children.count())
    }

    @Test
    fun testMultipleStartOnlyOneJob() = runTest {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        moduleEventsReporter.start()
        assertEquals(2, backgroundScope.coroutineContext.job.children.count { it.isCancelled })
        assertEquals(2, backgroundScope.coroutineContext.job.children.count { it.isActive })
    }

    @Test
    fun testStop() = runTest {
        val callEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        callEventsReporter.start()
        callEventsReporter.stop()
        assertEquals(2, backgroundScope.coroutineContext.job.children.count { it.isCancelled })
    }

    // CALL
    @Test
    fun onCallModuleDisconnectedShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conferenceState.value = State.Disconnected
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.CallModuleStatusChanged, CrossPlatformModuleStatus.Disconnected.name.lowercase()) }
    }

    @Test
    fun onCallModuleConnectingShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conferenceState.value = State.Connecting
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.CallModuleStatusChanged, CrossPlatformModuleStatus.Connecting.name.lowercase()) }
    }

    @Test
    fun onCallModuleReconnectingShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conferenceState.value = State.Connected
        conferenceState.value = State.Connecting
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.CallModuleStatusChanged, CrossPlatformModuleStatus.Reconnecting.name.lowercase()) }
    }

    @Test
    fun onCallModuleConnectedShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conferenceState.value = State.Connected
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.CallModuleStatusChanged, CrossPlatformModuleStatus.Connected.name.lowercase()) }
    }

    @Test
    fun onCallModuleFailedShouldSendEvent()  = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conferenceState.value = State.Disconnected.Error.ExpiredCredentials
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.CallModuleStatusChanged, CrossPlatformModuleStatus.Failed.name.lowercase()) }
    }

    @Test
    fun onCallModuleDisconnectingShouldNotSendEvent()  = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conferenceState.value = State.Disconnecting
        verify(exactly = 0) { eventsEmitter.sendEvent(Events.CallModuleStatusChanged, null) }
    }

    // CHAT
    @Test
    fun onChatModuleDisconnectedShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conversationState.value = State.Disconnected
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, CrossPlatformModuleStatus.Disconnected.name.lowercase()) }
    }

    @Test
    fun onChatModuleConnectedShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conversationState.value = State.Connected
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, CrossPlatformModuleStatus.Connected.name.lowercase()) }
    }

    @Test
    fun onChatModuleConnectingShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conversationState.value = State.Connecting
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, CrossPlatformModuleStatus.Connecting.name.lowercase()) }
    }

    @Test
    fun onChatModuleReconnectingShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conversationState.value = State.Connected
        conversationState.value = State.Connecting
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, CrossPlatformModuleStatus.Reconnecting.name.lowercase()) }
    }

    @Test
    fun onChatModuleFailedShouldSendEvent() = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conversationState.value = State.Disconnected.Error.ExpiredCredentials
        verify(exactly = 1) { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, CrossPlatformModuleStatus.Failed.name.lowercase()) }
    }

    @Test
    fun onChatModuleDisconnectingShouldNotSendEvent()  = runTest(UnconfinedTestDispatcher()) {
        val moduleEventsReporter = ModuleEventsReporter(sdk = sdk, eventsEmitter = eventsEmitter, backgroundScope)
        moduleEventsReporter.start()
        conversationState.value = State.Disconnecting
        verify(exactly = 0) { eventsEmitter.sendEvent(Events.CallModuleStatusChanged, null) }
    }
}
