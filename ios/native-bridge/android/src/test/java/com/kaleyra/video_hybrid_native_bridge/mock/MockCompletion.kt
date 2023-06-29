// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import com.bandyer.android_sdk.client.Completion

class MockCompletion : Completion<String> {

    var isSuccess = false
        private set

    var isError = false
        private set

    lateinit var getSuccessResult: String
    lateinit var getErrorResult: Throwable

    override fun error(error: Throwable) {
        isError = true
        getErrorResult = error
    }

    override fun success(data: String) {
        isSuccess = true
        getSuccessResult = data
    }
}
