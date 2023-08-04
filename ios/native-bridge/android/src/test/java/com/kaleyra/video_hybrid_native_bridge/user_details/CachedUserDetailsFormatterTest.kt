// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import com.bandyer.android_sdk.notification.FormatContext
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.UserDetailsFormat
import com.kaleyra.video_hybrid_native_bridge.mock.SharedPrefsUserDetailsFormatMock
import com.kaleyra.video_hybrid_native_bridge.mock.mockUserDetails
import io.mockk.mockk
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class CachedUserDetailsFormatterTest {

    private val sharedPrefsUserDetailsFormatMock = SharedPrefsUserDetailsFormatMock()
    private val context = sharedPrefsUserDetailsFormatMock.context

    private val mockUserDetails = mockUserDetails(
        userAlias = "user1",
        firstName = "firstName",
        lastName = "lastName",
        imageUrl = "imageUrl",
        displayName = "displayName",
        nickName = "nickName",
        email = "email"
    )

    @Test
    fun `test default format with cached user details formatter in sharedPrefs`() {
        sharedPrefsUserDetailsFormatMock.loadUserDetailsFormat()

        val cachedUserDetailsFormatter = CachedUserDetailsFormatter(context)
        val formattedUserDetails = cachedUserDetailsFormatter.format(mockUserDetails, FormatContext(mockk(), false))
        assertEquals("user1,email,firstName,imageUrl,displayName,lastName,nickName", formattedUserDetails)

        sharedPrefsUserDetailsFormatMock.checkPrefsLoaded()
    }

    @Test
    fun `test notification format with cached user details formatter in sharedPrefs`() {
        sharedPrefsUserDetailsFormatMock.loadUserDetailsFormat()

        val cachedUserDetailsFormatter = CachedUserDetailsFormatter(context)
        val formattedUserDetails = cachedUserDetailsFormatter.format(mockUserDetails, FormatContext(mockk(), true))
        assertEquals("notification = user1,email,firstName,imageUrl,displayName,lastName,nickName", formattedUserDetails)

        sharedPrefsUserDetailsFormatMock.checkPrefsLoaded()
    }

    @Test
    fun `test wrong key in the format with cached user details formatter in sharedPrefs`() {
        sharedPrefsUserDetailsFormatMock.loadWrongUserDetailsFormat()
        val cachedUserDetailsFormatter = CachedUserDetailsFormatter(context)

        val formattedUserDetails = cachedUserDetailsFormatter.format(mockUserDetails, FormatContext(mockk(), false))

        assertEquals("\${ciao}", formattedUserDetails)
        sharedPrefsUserDetailsFormatMock.checkPrefsLoaded()
    }

    @Test
    fun `test default format with cached user details formatter from constructor`() {
        val userDetailsFormat = UserDetailsFormat(default = "\${userAlias},\${email},\${firstName},\${imageUrl},\${displayName},\${lastName},\${nickName}")

        val cachedUserDetailsFormatter = CachedUserDetailsFormatter(context, userDetailsFormat)
        val formattedUserDetails = cachedUserDetailsFormatter.format(mockUserDetails, FormatContext(mockk(), false))
        assertEquals("user1,email,firstName,imageUrl,displayName,lastName,nickName", formattedUserDetails)

        sharedPrefsUserDetailsFormatMock.checkPrefsCommitted(userDetailsFormat)
    }

    @Test
    fun `test notification format with cached user details formatter from constructor`() {
        val userDetailsFormat = UserDetailsFormat(androidNotification = "not = \${userAlias},\${email},\${firstName},\${imageUrl},\${displayName},\${lastName},\${nickName}",
                                                  default = "")

        val cachedUserDetailsFormatter = CachedUserDetailsFormatter(context, userDetailsFormat)
        val formattedUserDetails = cachedUserDetailsFormatter.format(mockUserDetails, FormatContext(mockk(), true))
        assertEquals("not = user1,email,firstName,imageUrl,displayName,lastName,nickName", formattedUserDetails)

        sharedPrefsUserDetailsFormatMock.checkPrefsCommitted(userDetailsFormat)
    }


    @Test
    fun `test wrong format with cached user details formatter from constructor`() {
        val userDetailsFormat = UserDetailsFormat(androidNotification = "\${pluto}", default = "")

        val cachedUserDetailsFormatter = CachedUserDetailsFormatter(context, userDetailsFormat)
        val formattedUserDetails = cachedUserDetailsFormatter.format(mockUserDetails, FormatContext(mockk(), true))
        assertEquals("\${pluto}", formattedUserDetails)

        sharedPrefsUserDetailsFormatMock.checkPrefsCommitted(userDetailsFormat)
    }


}
