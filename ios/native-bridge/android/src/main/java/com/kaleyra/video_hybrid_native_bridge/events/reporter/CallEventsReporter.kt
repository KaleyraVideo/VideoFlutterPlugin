// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import androidx.appcompat.app.AppCompatActivity
import com.bandyer.android_sdk.call.CallException
import com.bandyer.android_sdk.call.CallObserver
import com.bandyer.android_sdk.call.CallUIObserver
import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.intent.call.Call
import com.kaleyra.video_hybrid_native_bridge.events.Events.CallError
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import java.lang.ref.WeakReference

class CallEventsReporter(
    private val sdk: BandyerSDKInstance,
    private val eventsEmitter: EventsEmitter
) : EventsReporter, CallObserver, CallUIObserver {

    private val failedCalls = HashMap<String, Call>()

    override fun start() {
        sdk.callModule!!.addCallObserver(this)
        sdk.callModule!!.addCallUIObserver(this)
    }

    override fun stop() {
        sdk.callModule!!.removeCallObserver(this)
        sdk.callModule!!.removeCallUIObserver(this)
    }

    override fun onCallEndedWithError(call: Call, callException: CallException) {
        val id = call.callInfo.callId
        if (failedCalls.containsKey(id)) return
        failedCalls[id] = call
        eventsEmitter.sendEvent(CallError, callException.localizedMessage)
    }

    override fun onActivityError(call: Call, activity: WeakReference<AppCompatActivity>, error: CallException) {
        val id = call.callInfo.callId
        if (failedCalls.containsKey(id)) return
        failedCalls[id] = call
        eventsEmitter.sendEvent(CallError, error.localizedMessage)
    }

    override fun onCallCreated(call: Call) = Unit
    override fun onCallEnded(call: Call) = Unit
    override fun onCallStarted(call: Call) = Unit

    override fun onActivityDestroyed(call: Call, activity: WeakReference<AppCompatActivity>) = Unit
    override fun onActivityStarted(call: Call, activity: WeakReference<AppCompatActivity>) = Unit
}
