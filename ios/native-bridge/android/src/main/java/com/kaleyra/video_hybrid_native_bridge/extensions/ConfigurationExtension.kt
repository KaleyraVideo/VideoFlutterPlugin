// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.client.BandyerSDKConfiguration
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptionsProxy
import com.kaleyra.video_hybrid_native_bridge.utils.TLSSocketFactoryCompat
import com.kaleyra.collaboration_suite_utils.logging.BaseLogger
import com.kaleyra.collaboration_suite_utils.logging.androidPrioryLogger
import okhttp3.OkHttpClient
import java.security.cert.X509Certificate
import javax.net.ssl.X509TrustManager

/**
 *
 * @author kristiyan
 */
internal fun KaleyraVideoConfiguration.toSDK(createCallOptionsProxy: CreateCallOptionsProxy) = BandyerSDKConfiguration.Builder(appID, environment.toSDK(), region.toSDK()).apply {
    tools {
        tools ?: return@tools
        val chatToolsConfiguration = tools.toChatConfiguration()
        val callToolsConfiguration = tools.toCallConfiguration(chatToolsConfiguration, createCallOptionsProxy)
        withCall { callConfiguration = callToolsConfiguration }
        chatToolsConfiguration ?: return@tools
        withChat { chatConfiguration = chatToolsConfiguration }
    }
    if (logEnabled == true) enableLogger()
    httpStack(trustedHttpClient())
}.build()

private fun BandyerSDKConfiguration.Builder.enableLogger() = logger(androidPrioryLogger(BaseLogger.VERBOSE, -1))

private fun trustedHttpClient() = OkHttpClient.Builder().sslSocketFactory(TLSSocketFactoryCompat(), object : X509TrustManager {
    override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
    override fun checkClientTrusted(certs: Array<X509Certificate>, authType: String) = Unit
    override fun checkServerTrusted(certs: Array<X509Certificate>, authType: String) = Unit
}).build()
