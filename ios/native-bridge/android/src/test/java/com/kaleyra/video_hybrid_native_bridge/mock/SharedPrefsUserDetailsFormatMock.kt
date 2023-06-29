// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import android.content.Context
import android.content.SharedPreferences
import com.kaleyra.video_hybrid_native_bridge.UserDetailsFormat
import com.kaleyra.video_hybrid_native_bridge.utils.getFileFromPath
import com.google.gson.Gson
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify

class SharedPrefsUserDetailsFormatMock {

    private val editPrefs = mockk<SharedPreferences.Editor>(relaxed = true)

    private val prefs = mockk<SharedPreferences>() {
        every { edit() } returns editPrefs
    }

    val context = mockk<Context> {
        every { getSharedPreferences("KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMATTER_PREFS", Context.MODE_PRIVATE) } returns prefs
    }

    fun loadUserDetailsFormat() {
        every { prefs.getString("KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT", "") } returns getFileFromPath(this, "UserDetailsFormatter.json").readText()
    }

    fun loadWrongUserDetailsFormat() {
        every { prefs.getString("KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT", "") } returns getFileFromPath(this, "WrongUserDetailsFormatter.json").readText()
    }

    fun checkPrefsLoaded() {
        verify { prefs.getString("KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT", "") }
    }

    fun checkPrefsCommitted(format: UserDetailsFormat) {
        val formatToString =  Gson().toJson(format)
        verify { editPrefs.putString("KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT",formatToString).commit() }
    }
}
