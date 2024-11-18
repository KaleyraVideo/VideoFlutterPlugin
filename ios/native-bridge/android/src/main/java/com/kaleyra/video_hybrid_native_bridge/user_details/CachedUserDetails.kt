// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import com.kaleyra.video_hybrid_native_bridge.UserDetails

interface CachedUserDetails {

    val cachedUserDetails: androidx.collection.ArraySet<UserDetails>

    fun addUsersDetails(userDetails: Array<UserDetails>)

    fun removeUserDetails()
}
