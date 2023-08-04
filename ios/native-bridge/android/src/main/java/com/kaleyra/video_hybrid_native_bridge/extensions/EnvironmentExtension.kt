// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_hybrid_native_bridge.Environment

internal fun Environment.toSDK() = when (name.lowercase()) {
    "sandbox"    -> com.kaleyra.collaboration_suite_networking.Environment.Sandbox
    "production" -> com.kaleyra.collaboration_suite_networking.Environment.Production
    else         -> com.kaleyra.collaboration_suite_networking.Environment.create(name)
}
