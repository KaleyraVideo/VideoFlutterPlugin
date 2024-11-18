// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_hybrid_native_bridge.Environment

internal fun Environment.toSDK() = when (name.lowercase()) {
    "sandbox"    -> com.kaleyra.video.configuration.Environment.Sandbox
    "production" -> com.kaleyra.video.configuration.Environment.Production
    else         -> com.kaleyra.video.configuration.Environment.create(name)
}
