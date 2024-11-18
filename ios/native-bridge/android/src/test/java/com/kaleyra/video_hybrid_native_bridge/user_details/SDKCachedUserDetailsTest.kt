// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import android.net.Uri
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_common_ui.model.UserDetailsProvider
import com.kaleyra.video_hybrid_native_bridge.UserDetails
import com.kaleyra.video_hybrid_native_bridge.mock.MockVideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.repository.UserDetailsEntity
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import io.mockk.slot
import io.mockk.verify
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RandomRunner::class)
class SDKCachedUserDetailsTest {

    private val sdk = mockk<KaleyraVideo>(relaxed = true)
    private val uriMock = mockk<Uri>()

    @Before
    fun setUp() {
        mockkStatic(Uri::class)
        every { Uri.parse("test/path") } returns uriMock
    }

    @Test
    fun loadUserDetailsFromDB() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository(mutableListOf(UserDetailsEntity(userID = "user1", name = "ciao")))
        val cachedUserDetails = SDKCachedUserDetails(sdk, db, this)
        advanceUntilIdle()
        verify(exactly = 0) { sdk.userDetailsProvider = any() }
        assertEquals(1, cachedUserDetails.cachedUserDetails.size)
        assertEquals(UserDetails(userID = "user1", name = "ciao"), cachedUserDetails.cachedUserDetails.first())
    }

    @Test
    fun addUserDetailsEmptyAlias() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository()
        val userDao = db.userDao
        val cachedUserDetails = SDKCachedUserDetails(sdk, db, this)
        cachedUserDetails.addUsersDetails(arrayOf(UserDetails(userID = "", name = "ciao")))
        advanceUntilIdle()
        verify(exactly = 0) { userDao.insert(any()) }
        assertEquals(0, cachedUserDetails.cachedUserDetails.size)
    }

    @Test
    fun addUserDetails() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository()
        val userDao = db.userDao
        val cachedUserDetails = SDKCachedUserDetails(sdk, db, this)
        cachedUserDetails.addUsersDetails(arrayOf(UserDetails(userID = "user1", name = "ciao", imageURL = "test/path")))
        advanceUntilIdle()
        verify { userDao.insert(listOf(UserDetailsEntity("user1", name = "ciao", imageUrl = "test/path"))) }
        val userDetailsProvider = slot<UserDetailsProvider>()
        verify { sdk.userDetailsProvider = capture(userDetailsProvider) }
        assertEquals(
            listOf(com.kaleyra.video_common_ui.model.UserDetails(userId = "user1", name = "ciao", image = uriMock)),
            userDetailsProvider.captured.invoke(listOf("user1")).getOrNull()
        )
        assertEquals(1, cachedUserDetails.cachedUserDetails.size)
        assertEquals(UserDetails(userID = "user1", name = "ciao", imageURL = "test/path"), cachedUserDetails.cachedUserDetails.first())
    }

    @Test
    fun removeUserDetails() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository()
        val cachedUserDetails = SDKCachedUserDetails(sdk, db, this)
        advanceUntilIdle()
        cachedUserDetails.addUsersDetails(arrayOf(UserDetails(userID = "user1", name = "ciao")))
        cachedUserDetails.removeUserDetails()
        advanceUntilIdle()
        verify(exactly = 1) { db.userDao.clear() }
        assertEquals(0, cachedUserDetails.cachedUserDetails.size)
    }
}
