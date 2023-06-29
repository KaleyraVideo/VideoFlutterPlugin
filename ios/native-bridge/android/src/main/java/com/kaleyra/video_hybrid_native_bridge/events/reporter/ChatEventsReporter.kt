// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import androidx.appcompat.app.AppCompatActivity
import com.bandyer.android_sdk.chat.ChatException
import com.bandyer.android_sdk.chat.ChatObserver
import com.bandyer.android_sdk.chat.ChatUIObserver
import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.intent.chat.Chat
import com.kaleyra.video_hybrid_native_bridge.events.Events.ChatError
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import java.lang.ref.WeakReference

class ChatEventsReporter(
    private val sdk: BandyerSDKInstance,
    private val eventsEmitter: EventsEmitter
) : EventsReporter, ChatObserver, ChatUIObserver {

    private val failedChats = HashMap<String, Chat>()

    override fun start() {
        sdk.chatModule?.addChatObserver(this)
        sdk.chatModule?.addChatUIObserver(this)
    }

    override fun stop() {
        sdk.chatModule?.removeChatObserver(this)
        sdk.chatModule?.removeChatUIObserver(this)
    }

    override fun onActivityError(chat: Chat, activity: WeakReference<AppCompatActivity>, error: ChatException) {
        val id = chat.chatInfo.chatId
        if (failedChats.containsKey(id)) return
        failedChats[id] = chat
        eventsEmitter.sendEvent(ChatError, error.localizedMessage)
    }

    override fun onActivityStarted(chat: Chat, activity: WeakReference<AppCompatActivity>) = Unit
    override fun onActivityDestroyed(chat: Chat, activity: WeakReference<AppCompatActivity>) = Unit
}
