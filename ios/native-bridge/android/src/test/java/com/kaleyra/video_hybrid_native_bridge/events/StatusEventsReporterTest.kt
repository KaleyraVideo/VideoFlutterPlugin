// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.events

import com.bandyer.android_sdk.call.CallModule
import com.bandyer.android_sdk.chat.ChatModule
import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.module.BandyerModuleStatus
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.events.Events.CallModuleStatusChanged
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Connecting
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Failed
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Ready
import com.kaleyra.video_hybrid_native_bridge.events.reporter.CrossPlatformModuleStatus.Stopped
import com.kaleyra.video_hybrid_native_bridge.events.reporter.ModuleEventsReporter
import io.mockk.mockk
import io.mockk.verify
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class ModuleEventsReporterTest {

    private val sdk = mockk<BandyerSDKInstance>(relaxed = true)
    private val eventsEmitter = mockk<EventsEmitter>(relaxed = true)
    private val moduleEventsReporter = ModuleEventsReporter(
        sdk = sdk,
        eventsEmitter = eventsEmitter
    )

    // CALL

    @Test
    fun onCallModuleDisconnectedShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<CallModule>(), BandyerModuleStatus.DISCONNECTED)
        verify { eventsEmitter.sendEvent(CallModuleStatusChanged, Stopped.name.lowercase()) }
    }

    @Test
    fun onCallModuleConnectingShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<CallModule>(), BandyerModuleStatus.CONNECTING)
        verify { eventsEmitter.sendEvent(CallModuleStatusChanged, Connecting.name.lowercase()) }
    }

    @Test
    fun onCallModuleConnectedShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<CallModule>(), BandyerModuleStatus.CONNECTED)
        verify { eventsEmitter.sendEvent(CallModuleStatusChanged, Ready.name.lowercase()) }
    }

    @Test
    fun onCallModuleReadyShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<CallModule>(), BandyerModuleStatus.READY)
        verify { eventsEmitter.sendEvent(CallModuleStatusChanged, Ready.name.lowercase()) }
    }

    @Test
    fun onCallModuleFailedShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<CallModule>(), BandyerModuleStatus.FAILED)
        verify { eventsEmitter.sendEvent(CallModuleStatusChanged, Failed.name.lowercase()) }
    }


    // CHAT
    @Test
    fun onChatModuleDisconnectedShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<ChatModule>(), BandyerModuleStatus.DISCONNECTED)
        verify { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, Stopped.name.lowercase()) }
    }

    @Test
    fun onChatModuleReadyShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<ChatModule>(), BandyerModuleStatus.READY)
        verify { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, Ready.name.lowercase()) }
    }

    @Test
    fun onChatModuleConnectingShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<ChatModule>(), BandyerModuleStatus.CONNECTING)
        verify { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, Connecting.name.lowercase()) }
    }

    @Test
    fun onChatModuleConnectedShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<ChatModule>(), BandyerModuleStatus.CONNECTED)
        verify { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, Ready.name.lowercase()) }
    }

    @Test
    fun onChatModuleFailedShouldSendEvent() {
        moduleEventsReporter.start()
        moduleEventsReporter.onModuleStatusChanged(mockk<ChatModule>(), BandyerModuleStatus.FAILED)
        verify { eventsEmitter.sendEvent(Events.ChatModuleStatusChanged, Failed.name.lowercase()) }
    }
}
