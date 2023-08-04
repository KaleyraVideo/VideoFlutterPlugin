// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events

import com.bandyer.android_sdk.chat.ChatException
import com.bandyer.android_sdk.chat.ChatModule
import com.bandyer.android_sdk.client.BandyerSDK
import com.bandyer.android_sdk.intent.chat.Chat
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.events.reporter.ChatEventsReporter
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class ChatEventsReporterTest {

    private val chatModule = mockk<ChatModule>(relaxed = true)
    private val sdk = mockk<BandyerSDK>(relaxed = true){
        every { chatModule } returns this@ChatEventsReporterTest.chatModule
    }
    private val eventsEmitter = mockk<EventsEmitter>(relaxed = true)
    private val chatEventsReporter = ChatEventsReporter(sdk, eventsEmitter)
    private val chat = mockk<Chat> {
        every { chatInfo } returns mockk {
            every { chatId } returns "chat"
        }
    }

    @Test
    fun onStartAddChatObserver() {
        chatEventsReporter.start()

        verify {
            chatModule.addChatObserver(chatEventsReporter)
            chatModule.addChatUIObserver(chatEventsReporter)
        }
    }

    @Test
    fun onStopAddChatObserver() {
        chatEventsReporter.stop()

        verify {
            chatModule.removeChatObserver(chatEventsReporter)
            chatModule.removeChatUIObserver(chatEventsReporter)
        }
    }

    @Test
    fun onChatActivityEndedWithErrorSendEvent() {
        chatEventsReporter.onActivityError(chat, mockk(), ChatException("error"))
        verify(atMost = 1) {
            eventsEmitter.sendEvent(Events.ChatError, "error")
        }
    }

    @Test
    fun onChatActivityEndedWithErrorTwiceShouldSendEventOnlyOnce() {
        chatEventsReporter.onActivityError(chat, mockk(), ChatException("error"))
        chatEventsReporter.onActivityError(chat, mockk(), ChatException("error"))
        verify(atMost = 1) {
            eventsEmitter.sendEvent(Events.ChatError, "error")
        }
    }
}
