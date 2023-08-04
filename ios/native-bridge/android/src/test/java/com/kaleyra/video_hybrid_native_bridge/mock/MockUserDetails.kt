// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

fun mockUserDetails(
    userAlias: String = "",
    firstName: String? = null,
    lastName: String? = null,
    email: String? = null,
    displayName: String? = null,
    nickName: String? = null,
    imageUrl: String? = null,
) = com.bandyer.android_sdk.utils.provider.UserDetails.Builder(userAlias).apply {
    email?.let { withEmail(email) }
    firstName?.let { withFirstName(firstName) }
    lastName?.let { withLastName(lastName) }
    nickName?.let { withNickName(nickName) }
    imageUrl?.let { withImageUrl(imageUrl) }
    displayName?.let { withDisplayName(displayName) }
}.build()
