// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.repository

import androidx.room.TypeConverter
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.google.gson.Gson

internal class Converters {

    private val gson by lazy { Gson() }

    @TypeConverter
    fun fromString(value: String?): KaleyraVideoConfiguration? {
        value ?: return null
        return gson.fromJson(value, KaleyraVideoConfiguration::class.java)
    }

    @TypeConverter
    fun toString(config: KaleyraVideoConfiguration?): String? {
        config ?: return null
        return gson.toJson(config)
    }
}
