// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events.reporter

import com.bandyer.android_sdk.call.CallModule
import com.bandyer.android_sdk.chat.ChatModule
import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.module.BandyerModule
import com.bandyer.android_sdk.module.BandyerModuleObserver
import com.bandyer.android_sdk.module.BandyerModuleStatus
import com.kaleyra.video_hybrid_native_bridge.events.Events.CallModuleStatusChanged
import com.kaleyra.video_hybrid_native_bridge.events.Events.ChatModuleStatusChanged
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter

class ModuleEventsReporter(
    val sdk: BandyerSDKInstance,
    val eventsEmitter: EventsEmitter
) : EventsReporter, BandyerModuleObserver {

    override fun start() = sdk.addModuleObserver(this)
    override fun stop() = sdk.removeModuleObserver(this)

    override fun onModuleStatusChanged(module: BandyerModule, moduleStatus: BandyerModuleStatus) = when (module) {
        is CallModule -> eventsEmitter.sendEvent(CallModuleStatusChanged, moduleStatus.toCrossPlatformModuleStatus())
        is ChatModule -> eventsEmitter.sendEvent(ChatModuleStatusChanged, moduleStatus.toCrossPlatformModuleStatus())
        else          -> Unit
    }

    override fun onModuleFailed(module: BandyerModule, throwable: Throwable) = Unit
    override fun onModulePaused(module: BandyerModule) = Unit
    override fun onModuleReady(module: BandyerModule) = Unit
}
