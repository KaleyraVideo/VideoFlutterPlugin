// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.repository

import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * @suppress
 * @author kristiyan
 */
@Entity
data class UserDetailsEntity(
    @PrimaryKey val userID: String,
    var name: String? = null,
    var imageUrl: String? = null
)
