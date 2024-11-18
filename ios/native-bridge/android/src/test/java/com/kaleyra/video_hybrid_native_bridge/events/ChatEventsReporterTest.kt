// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events

import com.kaleyra.video.conversation.Chat
import com.kaleyra.video_common_ui.ChatUI
import com.kaleyra.video_common_ui.ConversationUI
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.events.reporter.ChatEventsReporter
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.job
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RandomRunner::class)
class ChatEventsReporterTest {

    private val conversation = mockk<ConversationUI>(relaxed = true)
    private val sdk = mockk<KaleyraVideo>(relaxed = true){
        every { conversation } returns this@ChatEventsReporterTest.conversation
    }
    private val eventsEmitter = mockk<EventsEmitter>(relaxed = true)
    private val chat1 = mockk<ChatUI> {
        every { id } returns "chat1"
        every { state } returns MutableStateFlow(Chat.State.Closed)
    }
    private val chat2 = mockk<ChatUI> {
        every { id } returns "chat2"
        every { state } returns MutableStateFlow(Chat.State.Closed)
    }
    private val chat3 = mockk<ChatUI> {
        every { id } returns "chat3"
        every { state } returns MutableStateFlow(Chat.State.Closed)
    }

    @Test
    fun testStart() = runTest(UnconfinedTestDispatcher()) {
        every { conversation.chats } returns MutableStateFlow(listOf(chat1, chat2))
        val chatEventsReporter = ChatEventsReporter(sdk, eventsEmitter, backgroundScope)
        chatEventsReporter.start()
        assertEquals(3, backgroundScope.coroutineContext.job.children.count { it.isActive })
    }

    @Test
    fun testMultipleStart() = runTest(UnconfinedTestDispatcher()) {
        every { conversation.chats } returns MutableStateFlow(listOf(chat1, chat2))
        val chatEventsReporter = ChatEventsReporter(sdk, eventsEmitter, backgroundScope)
        chatEventsReporter.start()
        chatEventsReporter.start()
        advanceUntilIdle()
        assertEquals(3, backgroundScope.coroutineContext.job.children.count { it.isActive })
    }

    @Test
    fun testStop() = runTest(UnconfinedTestDispatcher()) {
        every { conversation.chats } returns MutableStateFlow(listOf(chat1, chat2))
        val chatEventsReporter = ChatEventsReporter(sdk, eventsEmitter, backgroundScope)
        chatEventsReporter.start()
        chatEventsReporter.stop()
        assertEquals(0, backgroundScope.coroutineContext.job.children.count { it.isActive })
    }

    @Test
    fun testJobsOnNewChats() = runTest(UnconfinedTestDispatcher()) {
        val chats = MutableStateFlow(listOf(chat1, chat2))
        every { conversation.chats } returns chats
        val chatEventsReporter = ChatEventsReporter(sdk, eventsEmitter, backgroundScope)
        chatEventsReporter.start()
        chats.value = listOf(chat1, chat2, chat3)
        assertEquals(4, backgroundScope.coroutineContext.job.children.count { it.isActive })
    }

    @Test
    fun onChatActivityEndedWithErrorSendEvent() = runTest(UnconfinedTestDispatcher()) {
        every { chat2.state } returns MutableStateFlow(Chat.State.Closed.Error)
        val chats = MutableStateFlow(listOf(chat1, chat2))
        every { conversation.chats } returns chats
        val chatEventsReporter = ChatEventsReporter(sdk, eventsEmitter, backgroundScope)
        chatEventsReporter.start()
        verify(atMost = 1) { eventsEmitter.sendEvent(Events.ChatError, "An error has occurred") }
    }
}
