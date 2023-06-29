// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import com.kaleyra.video_hybrid_native_bridge.UserDetails
import com.kaleyra.video_hybrid_native_bridge.UserDetailsFormat

interface CachedUserDetails {

    val cachedUserDetails: androidx.collection.ArraySet<UserDetails>

    fun setUserDetailsFormat(format: UserDetailsFormat)

    fun addUsersDetails(userDetails: Array<UserDetails>)

    fun removeUserDetails()
}
