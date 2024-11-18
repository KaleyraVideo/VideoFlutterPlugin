// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import com.kaleyra.video.conversation.Chat
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.events.Events.ChatError
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onEach

class ChatEventsReporter(
    private val sdk: KaleyraVideo,
    private val eventsEmitter: EventsEmitter,
    private val coroutineScope: CoroutineScope
) : EventsReporter {

    private val failedChats = HashMap<String, Chat>()

    private val chatJobs = HashMap<String, Job>()

    private var job: Job? = null

    override fun start() {
        stop()
        job = sdk.conversation.chats
            .onEach { chats ->
                chats.forEach { chat ->
                    chatJobs[chat.id]?.cancel()
                    chatJobs[chat.id] = chat.state.onEach eachState@ { state ->
                        if (state is Chat.State.Closed.Error) {
                            val id = chat.id
                            if (failedChats.containsKey(id)) return@eachState
                            failedChats[id] = chat
                            eventsEmitter.sendEvent(ChatError, state.reason)
                        }
                    }.launchIn(coroutineScope)
                }
            }
            .onCompletion { chatJobs.values.forEach { it.cancel() } }
            .launchIn(coroutineScope)
    }

    override fun stop() {
        job?.cancel()
        job = null
    }
}
