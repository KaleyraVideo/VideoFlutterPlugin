// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import com.bandyer.android_sdk.client.Completion
import com.bandyer.android_sdk.utils.provider.UserDetails
import org.junit.Assert

fun mockkSuccessUserDetailsProvided(userDetails: UserDetails) = object : Completion<Iterable<UserDetails>> {
    override fun success(data: Iterable<UserDetails>) {
        Assert.assertEquals(userDetails.userAlias, data.first().userAlias)
        Assert.assertEquals(userDetails.nickName, data.first().nickName)
        Assert.assertEquals(userDetails.firstName, data.first().firstName)
        Assert.assertEquals(userDetails.lastName, data.first().lastName)
        Assert.assertEquals(userDetails.displayName, data.first().displayName)
        Assert.assertEquals(userDetails.email, data.first().email)
        Assert.assertEquals(userDetails.imageUrl, data.first().imageUrl)
    }

    override fun error(error: Throwable) = Assert.fail()
}
