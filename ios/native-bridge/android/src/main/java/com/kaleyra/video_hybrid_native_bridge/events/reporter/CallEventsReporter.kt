// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import com.kaleyra.video.conference.Call
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.events.Events.CallError
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.onEach

class CallEventsReporter(
    private val sdk: KaleyraVideo,
    private val eventsEmitter: EventsEmitter,
    private val coroutineScope: CoroutineScope
) : EventsReporter {

    private val failedCalls = HashMap<String, Call>()

    private var job: Job? = null

    override fun start() {
        stop()
        job = sdk.conference.call
            .flatMapLatest { call -> call.state.map { call to it } }
            .onEach { (call, callState) ->
                if (callState is Call.State.Disconnected.Ended.Error) {
                    val id = call.id
                    if (failedCalls.containsKey(id)) return@onEach
                    failedCalls[id] = call
                    eventsEmitter.sendEvent(CallError, callState.reason)
                }
            }.launchIn(coroutineScope)
    }

    override fun stop() {
        job?.cancel()
        job = null
    }
}
