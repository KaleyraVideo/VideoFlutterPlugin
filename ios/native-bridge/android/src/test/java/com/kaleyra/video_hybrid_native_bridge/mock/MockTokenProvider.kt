// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import com.kaleyra.video_hybrid_native_bridge.CrossPlatformAccessTokenProvider

sealed class MockTokenProvider : CrossPlatformAccessTokenProvider {

    class Success(private val result: Result<String> = Result.success("token")) : MockTokenProvider() {
        override fun provideAccessToken(userId: String, completion: (Result<String>) -> Unit) = completion(result)
    }

    class Error(private val result: Result<String> = Result.failure(Throwable("failed"))) : MockTokenProvider() {
        override fun provideAccessToken(userId: String, completion: (Result<String>) -> Unit) = completion(result)
    }
}
