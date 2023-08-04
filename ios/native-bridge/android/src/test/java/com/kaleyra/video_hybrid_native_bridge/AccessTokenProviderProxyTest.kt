// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.kaleyra.video_hybrid_native_bridge.mock.MockCompletion
import com.kaleyra.video_hybrid_native_bridge.mock.MockTokenProvider.Error
import com.kaleyra.video_hybrid_native_bridge.mock.MockTokenProvider.Success
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class AccessTokenProviderProxyTest {

    @Test
    fun provideSuccess() {
        val sdkProxy = SDKAccessTokenProviderProxy(Success())
        val sdkCompletion = MockCompletion()
        sdkProxy.provideAccessToken("userId", sdkCompletion)
        assertEquals(true, sdkCompletion.isSuccess)
        assertEquals("token", sdkCompletion.getSuccessResult)
    }

    @Test
    fun provideError() {
        val sdkProxy = SDKAccessTokenProviderProxy(Error())
        val sdkCompletion = MockCompletion()
        sdkProxy.provideAccessToken("userId", sdkCompletion)
        assertEquals(true, sdkCompletion.isError)
        assertEquals("failed", sdkCompletion.getErrorResult.message)
    }

}
