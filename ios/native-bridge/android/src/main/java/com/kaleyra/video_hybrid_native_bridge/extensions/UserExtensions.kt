// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.utils.provider.UserDetails
import com.kaleyra.video_hybrid_native_bridge.repository.UserDetailsEntity

/**
 *
 * @author kristiyan
 */
internal fun UserDetailsEntity.toSDK(): UserDetails {
    return UserDetails.Builder(userAlias).also { builder ->

        firstName?.let { builder.withFirstName(it) }
        lastName?.let { builder.withLastName(it) }
        nickName?.let { builder.withNickName(it) }

        email?.let { builder.withEmail(it) }

        imageUrl?.let { builder.withImageUrl(it) }
    }.build()
}

internal fun UserDetailsEntity.toUserDetails(): com.kaleyra.video_hybrid_native_bridge.UserDetails = com.kaleyra.video_hybrid_native_bridge.UserDetails(
    email = this.email,
    userID = this.userAlias,
    firstName = this.firstName,
    lastName = this.lastName,
    nickName = this.nickName,
    profileImageURL = this.imageUrl
)

internal fun UserDetails.toUserDetailsEntity(): UserDetailsEntity = UserDetailsEntity(userAlias, firstName, lastName, nickName, email, imageUrl)
