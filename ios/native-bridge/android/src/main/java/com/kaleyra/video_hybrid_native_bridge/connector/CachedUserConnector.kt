// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.connector

interface CachedUserConnector {

    val lastConnectedUserId: String?

    fun connect(userID: String)

    fun disconnect()

    fun clearUserCache()
}
