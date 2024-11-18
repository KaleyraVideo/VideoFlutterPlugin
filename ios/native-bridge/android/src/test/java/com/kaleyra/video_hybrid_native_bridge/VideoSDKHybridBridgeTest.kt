// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.CallType.Audio
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Manual
import com.kaleyra.video_hybrid_native_bridge.configurator.CachedSDKConfigurator
import com.kaleyra.video_hybrid_native_bridge.connector.CachedUserConnector
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.mock.MockContextContainer
import com.kaleyra.video_hybrid_native_bridge.ui.UserInterfacePresenter
import com.kaleyra.video_hybrid_native_bridge.user_details.CachedUserDetails
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.mockk
import io.mockk.verify
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class VideoSDKHybridBridgeTest {

    private val createCallOptionsPropxy = CreateCallOptionsProxy()
    private val sdk = mockk<KaleyraVideo>(relaxed = true)
    private val uiPresenter = mockk<UserInterfacePresenter>(relaxed = true)
    private val context = MockContextContainer()
    private val cachedUserDetails = mockk<CachedUserDetails>(relaxed = true)
    private val configurator = mockk<CachedSDKConfigurator>(relaxed = true)
    private val tokenProvider = mockk<CrossPlatformAccessTokenProvider>(relaxed = true)
    private val eventsEmitter = mockk<EventsEmitter>(relaxed = true)
    private val connector = mockk<CachedUserConnector>(relaxed = true)

    private val plugin = VideoSDKHybridBridge(
        contextContainer = context,
        sdk = sdk,
        tokenProvider = tokenProvider,
        eventsEmitter = eventsEmitter,
        connector = connector,
        presenter = uiPresenter,
        configurator = configurator,
        userDetails = cachedUserDetails
    )

    @Test
    fun startCallWithRecording() {
        val createCallOptions = CreateCallOptions(listOf(""), Audio, Manual)
        plugin.startCall(createCallOptions)
        verify { uiPresenter.startCall(createCallOptions) }
    }

    @Test
    fun reset() {
        plugin.reset()
        verify { configurator.reset() }
        verify { connector.clearUserCache() }
        verify { cachedUserDetails.removeUserDetails() }
    }

    @Test
    fun clearUserCache() {
        plugin.clearUserCache()
        verify { cachedUserDetails.removeUserDetails() }
        verify { connector.clearUserCache() }
    }

}
