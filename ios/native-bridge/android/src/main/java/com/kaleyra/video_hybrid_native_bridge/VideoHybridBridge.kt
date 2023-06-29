// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.kaleyra.video_hybrid_native_bridge.configurator.CachedSDKConfigurator
import com.kaleyra.video_hybrid_native_bridge.connector.CachedUserConnector
import com.kaleyra.video_hybrid_native_bridge.events.EventsEmitter
import com.kaleyra.video_hybrid_native_bridge.ui.UserInterfacePresenter
import com.kaleyra.video_hybrid_native_bridge.user_details.CachedUserDetails

interface VideoHybridBridge : CachedUserConnector, UserInterfacePresenter, CachedUserDetails, CachedSDKConfigurator {

    val contextContainer: ContextContainer

    val tokenProvider: CrossPlatformAccessTokenProvider

    val eventsEmitter: EventsEmitter
    fun verifyCurrentCall(verify: Boolean)
    fun handlePushNotificationPayload(payload: String)
}
