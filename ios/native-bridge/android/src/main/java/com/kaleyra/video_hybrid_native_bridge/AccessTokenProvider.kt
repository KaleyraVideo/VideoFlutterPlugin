// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge

interface CrossPlatformAccessTokenProvider {
    fun provideAccessToken(userId: String, completion: (Result<String>) -> Unit)
}
