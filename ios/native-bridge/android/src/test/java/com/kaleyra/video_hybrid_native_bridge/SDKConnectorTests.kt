// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.kaleyra.video_hybrid_native_bridge.connector.VideoSDKCachedUserConnector
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import com.kaleyra.video_hybrid_native_bridge.mock.MockVideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.repository.ConnectedUserEntity
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RandomRunner::class)
class SDKConnectorTests {

    private val sdk = mockk<BandyerSDKInstance>(relaxed = true)
    private val tokenProvider = mockk<CrossPlatformAccessTokenProvider>(relaxed = true)
    private val eventsReporter = mockk<EventsReporter>(relaxed = true)
    private val repository = MockVideoHybridBridgeRepository()

    @Test
    fun loadFromRepositoryAtInit() = runTest(CoroutineName("io")) {
        val repository = MockVideoHybridBridgeRepository(connectedUser = ConnectedUserEntity("ciao"))
        val sdkConnector = VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, this)
        advanceUntilIdle()
        with(repository.connectedUserDao) {
            verify(exactly = 1) { user }
        }
        assertEquals("ciao", sdkConnector.lastConnectedUserId)
    }

    @Test
    fun connect() = runTest(CoroutineName("io")) {
        val sdkConnector =
            VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, this)
        val session = slot<com.bandyer.android_sdk.client.Session>()
        sdkConnector.connect("userId")
        advanceUntilIdle()
        verify { sdk.connect(capture(session)) }
        verify { eventsReporter.start() }
        with(repository.connectedUserDao) {
            verify { insert(any()) }
        }
        assertEquals(session.captured.accessTokenProvider, sdkConnector.accessTokenProviderProxy)
        assertEquals("userId", sdkConnector.lastConnectedUserId)
        assertEquals("userId", session.captured.userId)
    }

    @Test
    fun disconnect() = runTest(CoroutineName("io")) {
        val sdkConnector =
            VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, this)
        sdkConnector.connect("userId")
        sdkConnector.disconnect()
        advanceUntilIdle()
        verify { sdk.disconnect() }
        verify { eventsReporter.stop() }
        assertEquals("userId", sdkConnector.lastConnectedUserId)
    }

    @Test
    fun clearUserCache() = runTest(CoroutineName("io")) {
        val sdkConnector =
            VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, this)
        sdkConnector.connect("userId")
        sdkConnector.clearUserCache()
        advanceUntilIdle()
        verify { sdk.disconnect(true) }
        verify { eventsReporter.stop() }
        with(repository.connectedUserDao) {
            verify { clear() }
        }
        assertEquals(null, sdkConnector.lastConnectedUserId)
    }
}
