// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

class SDKEventsReporter internal constructor(
    private val moduleEventsReporter: ModuleEventsReporter,
    private val callEventsReporter: CallEventsReporter,
    private val chatEventsReporter: ChatEventsReporter,
    private val scope: CoroutineScope
) : EventsReporter {

    companion object {

        private var instance: SDKEventsReporter? = null

        fun create(
            sdk: KaleyraVideo,
            eventsEmitter: EventsEmitter,
            scope: CoroutineScope
        ): SDKEventsReporter = instance.takeIf { it?.isRunning == true } ?: SDKEventsReporter(sdk, eventsEmitter, scope).apply { instance = this }
    }

    private constructor(
        sdk: KaleyraVideo,
        eventsEmitter: EventsEmitter,
        scope: CoroutineScope
    ) : this(
        ModuleEventsReporter(sdk, eventsEmitter, scope),
        CallEventsReporter(sdk, eventsEmitter, scope),
        ChatEventsReporter(sdk, eventsEmitter, scope),
        scope
    )

    private var isRunning = false

    override fun start() {
        scope.launch {
            if (isRunning) return@launch
            isRunning = true
            moduleEventsReporter.start()
            callEventsReporter.start()
            chatEventsReporter.start()
        }
    }

    override fun stop() {
        scope.launch {
            if (!isRunning) return@launch
            isRunning = false
            moduleEventsReporter.stop()
            callEventsReporter.stop()
            chatEventsReporter.stop()
        }
    }

}
