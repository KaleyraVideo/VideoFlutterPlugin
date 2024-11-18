// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import com.kaleyra.video.State
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.events.Events.CallModuleStatusChanged
import com.kaleyra.video_hybrid_native_bridge.events.Events.ChatModuleStatusChanged
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.mapNotNull
import kotlinx.coroutines.flow.onEach

class ModuleEventsReporter(
    val sdk: KaleyraVideo,
    val eventsEmitter: EventsEmitter,
    val coroutineScope: CoroutineScope
) : EventsReporter {

    private var jobs: MutableSet<Job> = mutableSetOf()

    private var previousCallState: State? = null

    private var previousChatState: State? = null

    override fun start() {
        stop()
        jobs += sdk.conference.state
            .mapNotNull { state ->
                state.toCrossPlatformModuleStatus(previousCallState).also {
                    previousCallState = state
                }
            }
            .onEach { state -> eventsEmitter.sendEvent(CallModuleStatusChanged, state) }
            .launchIn(coroutineScope)
        jobs += sdk.conversation.state
            .mapNotNull { state ->
                state.toCrossPlatformModuleStatus(previousChatState).also {
                    previousChatState = state
                }
            }
            .onEach { state -> eventsEmitter.sendEvent(ChatModuleStatusChanged, state) }
            .launchIn(coroutineScope)
    }

    override fun stop() {
        previousCallState = null
        previousChatState = null
        jobs.forEach { it.cancel() }
        jobs.clear()
    }
}
