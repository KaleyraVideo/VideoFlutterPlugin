// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.bandyer.android_sdk.client.BandyerSDK
import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.kaleyra.video_hybrid_native_bridge.configurator.CachedSDKConfigurator
import com.kaleyra.video_hybrid_native_bridge.configurator.VideoSDKConfigurator
import com.kaleyra.video_hybrid_native_bridge.connector.VideoSDKCachedUserConnector
import com.kaleyra.video_hybrid_native_bridge.connector.CachedUserConnector
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import com.kaleyra.video_hybrid_native_bridge.events.reporter.SDKEventsReporter
import com.kaleyra.video_hybrid_native_bridge.repository.VideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.ui.SDKUserInterfacePresenter
import com.kaleyra.video_hybrid_native_bridge.ui.UserInterfacePresenter
import com.kaleyra.video_hybrid_native_bridge.user_details.CachedUserDetails
import com.kaleyra.video_hybrid_native_bridge.user_details.SDKCachedUserDetails
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.asCoroutineDispatcher
import java.util.concurrent.Executors

class VideoSDKHybridBridge(
  override val contextContainer: ContextContainer,
  override val tokenProvider: CrossPlatformAccessTokenProvider,
  override val eventsEmitter: EventsEmitter,
  private val sdk: BandyerSDKInstance = BandyerSDK.getInstance(),
  private val presenter: UserInterfacePresenter = SDKUserInterfacePresenter(sdk, contextContainer),
  private val backgroundScope: CoroutineScope = CoroutineScope(Executors.newSingleThreadExecutor().asCoroutineDispatcher()),
  private val eventsReporter: EventsReporter = SDKEventsReporter.create(sdk, eventsEmitter, backgroundScope),
  private val repository: VideoHybridBridgeRepository = VideoHybridBridgeRepository.getInstance(contextContainer.context.applicationContext),
  private val connector: CachedUserConnector = VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, backgroundScope),
  private val userDetails: CachedUserDetails = SDKCachedUserDetails(sdk, contextContainer, repository, backgroundScope),
  private val createCallOptionsProxy: CreateCallOptionsProxy = CreateCallOptionsProxy(),
  private val configurator: CachedSDKConfigurator = VideoSDKConfigurator(sdk, createCallOptionsProxy, repository, backgroundScope),
) : VideoHybridBridge,
    CachedUserConnector by connector,
    UserInterfacePresenter by presenter,
    CachedUserDetails by userDetails,
    CachedSDKConfigurator by configurator {

    override fun handlePushNotificationPayload(payload: String) = sdk.handleNotification(payload.replace("\\", ""))

    override fun reset() {
        configurator.reset()
        clearUserCache()
    }

    override fun clearUserCache() {
        connector.clearUserCache()
        removeUserDetails()
    }

    override fun startCall(callOptions: CreateCallOptions) {
        createCallOptionsProxy.createCallOptions = callOptions
        presenter.startCall(callOptions)
    }

    override fun verifyCurrentCall(verify: Boolean) {
        val ongoingCall = sdk.callModule?.ongoingCall ?: return
        sdk.callModule?.setVerified(ongoingCall, verify)
    }
}
