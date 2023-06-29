// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_hybrid_native_bridge.Region

internal fun Region.toSDK() = when (name.lowercase()) {
    "europe" -> com.kaleyra.collaboration_suite_networking.Region.Eu
    "india"  -> com.kaleyra.collaboration_suite_networking.Region.In
    "us"     -> com.kaleyra.collaboration_suite_networking.Region.Us
    else     -> com.kaleyra.collaboration_suite_networking.Region.create(name)
}
