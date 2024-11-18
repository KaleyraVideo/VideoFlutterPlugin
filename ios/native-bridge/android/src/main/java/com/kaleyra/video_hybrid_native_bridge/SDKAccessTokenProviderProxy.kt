// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

internal class SDKAccessTokenProviderProxy(val tokenProvider: CrossPlatformAccessTokenProvider) {
    suspend fun provideAccessToken(userId: String): Result<String> {
        return suspendCoroutine { continuation ->
            tokenProvider.provideAccessToken(userId) {
                if (it.isSuccess) continuation.resume(Result.success(it.getOrThrow()))
                else continuation.resume(Result.failure(it.exceptionOrNull() ?: Throwable("connection error")))
            }
        }
    }
}
