// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.utils.provider.UserDetailsProvider
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.UserDetails
import com.kaleyra.video_hybrid_native_bridge.UserDetailsFormat
import com.kaleyra.video_hybrid_native_bridge.mock.MockContextContainer
import com.kaleyra.video_hybrid_native_bridge.mock.MockVideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.mock.mockUserDetails
import com.kaleyra.video_hybrid_native_bridge.mock.mockkSuccessUserDetailsProvided
import com.kaleyra.video_hybrid_native_bridge.repository.UserDetailsEntity
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
class SDKCachedUserDetailsTest {

    private val contextContainer = MockContextContainer()
    private val sdk = mockk<BandyerSDKInstance>(relaxed = true)

    @Test
    fun loadUserDetailsFromDB() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository(mutableListOf(UserDetailsEntity(userAlias = "user1", nickName = "ciao")))
        val cachedUserDetails = SDKCachedUserDetails(sdk, contextContainer, db, this)
        advanceUntilIdle()
        verify(exactly = 0) { sdk.setUserDetailsProvider(any()) }
        assertEquals(1, cachedUserDetails.cachedUserDetails.size)
        assertEquals(UserDetails(userID = "user1", nickName = "ciao"), cachedUserDetails.cachedUserDetails.first())
    }

    @Test
    fun testSetUserDetailsFormat() = runTest(CoroutineName("io")) {
        val cachedUserDetails = SDKCachedUserDetails(sdk, contextContainer, MockVideoHybridBridgeRepository(), this)
        advanceUntilIdle()
        cachedUserDetails.setUserDetailsFormat(UserDetailsFormat(default = "ciao \${nickName}"))
        val cachedUserDetailsFormat = slot<CachedUserDetailsFormatter>()
        verify { sdk.setUserDetailsFormatter(capture(cachedUserDetailsFormat)) }
    }

    @Test
    fun addUserDetailsEmptyAlias() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository()
        val userDao = db.userDao
        val cachedUserDetails = SDKCachedUserDetails(sdk, contextContainer, db, this)
        cachedUserDetails.addUsersDetails(arrayOf(UserDetails(userID = "", nickName = "ciao")))
        advanceUntilIdle()
        verify(exactly = 0) { userDao.insert(any()) }
        assertEquals(0, cachedUserDetails.cachedUserDetails.size)
    }

    @Test
    fun addUserDetails() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository()
        val userDao = db.userDao
        val cachedUserDetails = SDKCachedUserDetails(sdk, contextContainer, db, this)
        cachedUserDetails.addUsersDetails(arrayOf(UserDetails(userID = "user1", nickName = "ciao")))
        advanceUntilIdle()
        verify { userDao.insert(listOf(UserDetailsEntity("user1", nickName = "ciao"))) }
        val userDetailsProvider = slot<UserDetailsProvider>()
        verify { sdk.setUserDetailsProvider(capture(userDetailsProvider)) }
        val mockedSuccessCompletion = mockkSuccessUserDetailsProvided(mockUserDetails("user1", nickName = "ciao"))
        userDetailsProvider.captured.onUserDetailsRequested(listOf("user1"), mockedSuccessCompletion)
        assertEquals(1, cachedUserDetails.cachedUserDetails.size)
        assertEquals(UserDetails(userID = "user1", nickName = "ciao"), cachedUserDetails.cachedUserDetails.first())
    }

    @Test
    fun removeUserDetails() = runTest(CoroutineName("io")) {
        val db = MockVideoHybridBridgeRepository()
        val cachedUserDetails = SDKCachedUserDetails(sdk, contextContainer, db, this)
        advanceUntilIdle()
        cachedUserDetails.addUsersDetails(arrayOf(UserDetails(userID = "user1", nickName = "ciao")))
        cachedUserDetails.removeUserDetails()
        advanceUntilIdle()
        verify(exactly = 1) { db.userDao.clear() }
        assertEquals(0, cachedUserDetails.cachedUserDetails.size)
    }
}
