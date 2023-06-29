// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

import com.bandyer.android_sdk.client.AccessTokenProvider
import com.bandyer.android_sdk.client.Completion

internal class SDKAccessTokenProviderProxy(val tokenProvider: CrossPlatformAccessTokenProvider) : AccessTokenProvider {
    override fun provideAccessToken(userId: String, completion: Completion<String>) {
        tokenProvider.provideAccessToken(userId) {
            if (it.isSuccess) completion.success(it.getOrThrow())
            else completion.error(it.exceptionOrNull() ?: Throwable("connection error"))
        }
    }
}
