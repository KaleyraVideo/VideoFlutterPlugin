// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.utils

import java.io.File

fun getFileFromPath(obj: Any, fileName: String): File {
    val classLoader = obj.javaClass.classLoader
    val resource = classLoader!!.getResource(fileName)
    return File(resource.path)
}
