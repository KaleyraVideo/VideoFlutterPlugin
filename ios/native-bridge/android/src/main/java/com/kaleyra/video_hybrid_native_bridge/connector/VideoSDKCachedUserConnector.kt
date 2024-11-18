// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.connector

import androidx.annotation.VisibleForTesting
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.CrossPlatformAccessTokenProvider
import com.kaleyra.video_hybrid_native_bridge.SDKAccessTokenProviderProxy
import com.kaleyra.video_hybrid_native_bridge.Session
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import com.kaleyra.video_hybrid_native_bridge.repository.ConnectedUserEntity
import com.kaleyra.video_hybrid_native_bridge.repository.VideoHybridBridgeRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

internal class VideoSDKCachedUserConnector(
    private val sdk: KaleyraVideo,
    private val repository: VideoHybridBridgeRepository,
    private val tokenProvider: CrossPlatformAccessTokenProvider,
    private val eventsReporter: EventsReporter,
    private val scope: CoroutineScope
) : CachedUserConnector {

    override var lastConnectedUserId: String? = null

    @VisibleForTesting
    internal val accessTokenProviderProxy = SDKAccessTokenProviderProxy(tokenProvider)

    override fun connect(userID: String) {
        scope.launch {
            repository.connectedUserDao().insert(ConnectedUserEntity(userID))
            eventsReporter.start()
            val connectedUser = kotlin.runCatching {
                sdk.connect(userID) { accessTokenProviderProxy.provideAccessToken(userID) }.await()
            }.getOrNull()
            lastConnectedUserId = connectedUser?.userId
        }
    }

    override fun disconnect() {
        scope.launch {
            eventsReporter.stop()
            sdk.disconnect()
        }
    }

    override fun clearUserCache() {
        scope.launch {
            repository.connectedUserDao().clear()
            disconnect()
            sdk.disconnect(true)
            lastConnectedUserId = null
        }
    }

    init {
        scope.launch {
            lastConnectedUserId = repository.connectedUserDao().user?.user
        }
    }
}
