// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.utils

import com.google.gson.Gson
import com.google.gson.TypeAdapter
import com.google.gson.TypeAdapterFactory
import com.google.gson.reflect.TypeToken
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonToken.NULL
import com.google.gson.stream.JsonWriter
import java.io.IOException

class CaseInsensitiveEnumTypeAdapterFactory : TypeAdapterFactory {
    override fun <T> create(gson: Gson, type: TypeToken<T>): TypeAdapter<T>? {
        val rawType = type.rawType as Class<T>
        if (!rawType.isEnum) {
            return null
        }
        val lowercaseToConstant: MutableMap<String, T> = HashMap()
        for (constant in rawType.enumConstants) lowercaseToConstant[toLowercase(constant!!)] = constant
        return object : TypeAdapter<T>() {
            @Throws(IOException::class)
            override fun write(out: JsonWriter, value: T?) {
                if (value == null) {
                    out.nullValue()
                } else {
                    out.value(value.toString())
                }
            }

            @Throws(IOException::class)
            override fun read(reader: JsonReader): T? {
                return if (reader.peek() == NULL) {
                    reader.nextNull()
                    null
                } else {
                    lowercaseToConstant[toLowercase(reader.nextString())]
                }
            }
        }
    }

    private fun toLowercase(o: Any): String {
        return o.toString().lowercase()
    }
}
