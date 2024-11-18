// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import android.net.Uri
import com.kaleyra.video_common_ui.model.UserDetails
import com.kaleyra.video_hybrid_native_bridge.repository.UserDetailsEntity

/**
 *
 * @author kristiyan
 */
internal fun UserDetailsEntity.toSDK(): UserDetails {
    return UserDetails(
        userId = userID,
        name = name ?: userID,
        image = imageUrl?.let { Uri.parse(it) } ?: Uri.EMPTY
    )
}

internal fun com.kaleyra.video_hybrid_native_bridge.UserDetails.toSDK(): UserDetails {
    return UserDetails(
        userId = userID,
        name = name ?: userID,
        image = imageURL?.let { Uri.parse(it) } ?: Uri.EMPTY
    )
}

internal fun com.kaleyra.video_hybrid_native_bridge.UserDetails.toDatabaseEntity(): UserDetailsEntity {
    return UserDetailsEntity(
        userID = userID,
        name = name,
        imageUrl = imageURL
    )
}

internal fun UserDetailsEntity.toUserDetails(): com.kaleyra.video_hybrid_native_bridge.UserDetails = com.kaleyra.video_hybrid_native_bridge.UserDetails(
    userID = this.userID,
    name = this.name,
    imageURL = this.imageUrl
)
