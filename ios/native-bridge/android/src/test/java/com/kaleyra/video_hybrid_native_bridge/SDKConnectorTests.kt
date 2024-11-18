// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.kaleyra.video.User
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.connector.VideoSDKCachedUserConnector
import com.kaleyra.video_hybrid_native_bridge.events.EventsReporter
import com.kaleyra.video_hybrid_native_bridge.mock.MockVideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.repository.ConnectedUserEntity
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.every
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import java.util.Date

@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RandomRunner::class)
class SDKConnectorTests {

    private val sdk = mockk<KaleyraVideo>(relaxed = true) {
        every { connect("userId", any()) } answers  {
            CompletableDeferred(object : User { override val userId = "userId" })
        }
    }
    private val tokenProvider = mockk<CrossPlatformAccessTokenProvider>(relaxed = true) {
        every { provideAccessToken("userId", any()) } answers {
            secondArg<(Result<String>) -> Unit>().invoke(Result.success(firstArg()))
        }
    }
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
        val sdkConnector = VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, this)
        sdkConnector.connect("userId")
        advanceUntilIdle()
        val slot = slot<suspend (Date) -> Result<String>>()
        verify { sdk.connect(userId = "userId", capture(slot)) }
        verify { eventsReporter.start() }
        with(repository.connectedUserDao) {
            verify { insert(any()) }
        }
        assertEquals(Result.success("userId"), slot.captured.invoke(Date()))
        assertEquals("userId", sdkConnector.lastConnectedUserId)
    }

    @Test
    fun disconnect() = runTest(CoroutineName("io")) {
        val sdkConnector = VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, this)
        sdkConnector.connect("userId")
        sdkConnector.disconnect()
        advanceUntilIdle()
        verify { sdk.disconnect() }
        verify { eventsReporter.stop() }
        assertEquals("userId", sdkConnector.lastConnectedUserId)
    }

    @Test
    fun clearUserCache() = runTest(CoroutineName("io")) {
        val sdkConnector = VideoSDKCachedUserConnector(sdk, repository, tokenProvider, eventsReporter, this)
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
