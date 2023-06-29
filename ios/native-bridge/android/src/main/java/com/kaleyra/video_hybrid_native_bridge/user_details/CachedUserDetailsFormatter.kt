// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.user_details

import android.annotation.SuppressLint
import android.content.Context
import com.bandyer.android_sdk.notification.FormatContext
import com.bandyer.android_sdk.utils.provider.UserDetails
import com.bandyer.android_sdk.utils.provider.UserDetailsFormatter
import com.kaleyra.video_hybrid_native_bridge.UserDetailsFormat
import com.google.gson.Gson
import java.util.regex.Pattern
import kotlin.reflect.full.declaredMemberProperties

internal class CachedUserDetailsFormatter private constructor() : UserDetailsFormatter {

    private lateinit var context: Context
    private lateinit var userDetailsFormat: UserDetailsFormat

    private val preferences by lazy { context.getSharedPreferences(KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMATTER_PREFS, Context.MODE_PRIVATE) }
    private val gson by lazy { Gson() }

    constructor(context: Context) : this() {
        this.context = context
        userDetailsFormat = gson.fromJson(preferences.getString(KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT, ""), UserDetailsFormat::class.java)
    }

    @SuppressLint("ApplySharedPref")
    constructor(context: Context, userDetailsFormat: UserDetailsFormat) : this() {
        this.context = context
        this.userDetailsFormat = userDetailsFormat
        preferences.edit().putString(KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT, gson.toJson(userDetailsFormat)).commit()
    }

    override fun format(userDetails: UserDetails, context: FormatContext): String = with(userDetails) {
        if (context.isNotification) userDetailsFormat.androidNotification?.let { formatBy(it) } ?: formatBy(userDetailsFormat.default)
        else formatBy(userDetailsFormat.default)
    }

    private fun UserDetails.formatBy(textToFormat: String): String {
        var output = textToFormat
        val regex = "(?<=\\$\\{)(.*?)(?=\\})";
        val p = Pattern.compile(regex);
        val m = p.matcher(textToFormat);
        while (m.find()) {
            val keyword = m.group()
            val value = UserDetails::class::declaredMemberProperties.get().firstOrNull { it.name == keyword }
            output = output.replace("\${$keyword}", value?.call(this)?.toString() ?: "\${$keyword}")
        }
        return output
    }

    companion object {
        private const val KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMATTER_PREFS = "KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMATTER_PREFS"
        private const val KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT = "KALEYRA_VIDEO_CACHED_USER_DETAILS_FORMAT"
    }

}
