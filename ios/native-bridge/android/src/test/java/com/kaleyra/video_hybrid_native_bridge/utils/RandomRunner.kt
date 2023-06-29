// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.utils

import org.junit.runners.BlockJUnit4ClassRunner
import org.junit.runners.model.FrameworkMethod
import org.junit.runners.model.InitializationError

internal class RandomRunner @Throws(InitializationError::class) constructor(klass: Class<*>) : BlockJUnit4ClassRunner(klass) {

    override fun computeTestMethods(): List<FrameworkMethod> {
        val methods = super.computeTestMethods().toMutableList().sortedBy { it.name.toString() }
        methods.shuffled()
        return methods
    }
}
