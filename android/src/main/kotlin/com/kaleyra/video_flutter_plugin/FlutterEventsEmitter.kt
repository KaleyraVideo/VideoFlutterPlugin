// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_flutter_plugin

import com.kaleyra.video_hybrid_native_bridge.events.Events
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

class FlutterEventsEmitter(private val channel: MethodChannel, private val scope: CoroutineScope) : EventsEmitter {
    override fun sendEvent(event: Events, args: Any?) {
        scope.launch { channel.invokeMethod(event.value, VideoNativePlugin.gson.toJson(args)) }
    }
}