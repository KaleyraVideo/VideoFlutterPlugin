// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_flutter_plugin

import com.kaleyra.video_hybrid_native_bridge.CrossPlatformAccessTokenProvider
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

class FlutterTokenProvider(
    private val channel: MethodChannel,
    private val scope: CoroutineScope
) : CrossPlatformAccessTokenProvider {

    companion object {
        private const val REQUEST_TOKEN_METHOD = "accessTokenRequest"
    }

    override fun provideAccessToken(userId: String, completion: (Result<String>) -> Unit) {
        scope.launch {
            channel.invokeMethod(REQUEST_TOKEN_METHOD, userId, FlutterTokenCompletionChannel(completion))
        }
    }

    private inner class FlutterTokenCompletionChannel(val completion: (Result<String>) -> Unit) : MethodChannel.Result {
        override fun success(result: Any?) = completion(Result.success(result.toString()))
        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) = completion(Result.failure(Exception(errorMessage)))
        override fun notImplemented() = completion(Result.failure(NotImplementedError()))
    }
}