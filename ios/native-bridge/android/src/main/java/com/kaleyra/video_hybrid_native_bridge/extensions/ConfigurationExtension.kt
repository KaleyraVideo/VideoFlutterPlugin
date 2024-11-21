// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video.configuration.Configuration
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.utils.TLSSocketFactoryCompat
import com.kaleyra.video_utils.logging.BaseLogger
import com.kaleyra.video_utils.logging.androidPrioryLogger
import okhttp3.OkHttpClient
import java.security.cert.X509Certificate
import javax.net.ssl.X509TrustManager

/**
 *
 * @author kristiyan
 */
internal fun KaleyraVideoConfiguration.toSDK() =
    Configuration(
        appId = appID,
        environment = environment.toSDK(),
        region = region.toSDK(),
        httpStack = trustedHttpClient(),
        logger = if (logEnabled == true) androidPrioryLogger(BaseLogger.VERBOSE, -1) else null
    )

private fun trustedHttpClient() =
    OkHttpClient.Builder().sslSocketFactory(TLSSocketFactoryCompat(), object : X509TrustManager {
        override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
        override fun checkClientTrusted(certs: Array<X509Certificate>, authType: String) = Unit
        override fun checkServerTrusted(certs: Array<X509Certificate>, authType: String) = Unit
    }).build()
