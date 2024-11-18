// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.kaleyra.video_hybrid_native_bridge.mock.MockTokenProvider.Error
import com.kaleyra.video_hybrid_native_bridge.mock.MockTokenProvider.Success
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class AccessTokenProviderProxyTest {

    @Test
    fun provideSuccess() = runBlocking {
        val sdkProxy = SDKAccessTokenProviderProxy(Success())
        val result = sdkProxy.provideAccessToken("userId")
        assertEquals(true, result.isSuccess)
        assertEquals("token", result.getOrNull())
    }

    @Test
    fun provideError() = runBlocking {
        val sdkProxy = SDKAccessTokenProviderProxy(Error())
        val result = sdkProxy.provideAccessToken("userId")
        assertEquals(true, result.isFailure)
        assertEquals("failed", result.exceptionOrNull()!!.message)
    }

}
