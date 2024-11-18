// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_hybrid_native_bridge.Region

internal fun Region.toSDK() = when (name.lowercase()) {
    "europe" -> com.kaleyra.video.configuration.Region.Europe
    "india"  -> com.kaleyra.video.configuration.Region.India
    "us"     -> com.kaleyra.video.configuration.Region.US
    else     -> com.kaleyra.video.configuration.Region.create(name)
}
