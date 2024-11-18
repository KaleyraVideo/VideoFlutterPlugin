// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video_common_ui.ConferenceUI
import com.kaleyra.video_common_ui.ConversationUI
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.AudioCallOptions
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.Audio
import com.kaleyra.video_hybrid_native_bridge.CallOptions
import com.kaleyra.video_hybrid_native_bridge.ChatToolConfiguration
import com.kaleyra.video_hybrid_native_bridge.Environment
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Automatic
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Manual
import com.kaleyra.video_hybrid_native_bridge.Region
import com.kaleyra.video_hybrid_native_bridge.ScreenShareToolConfiguration
import com.kaleyra.video_hybrid_native_bridge.Tools
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video_hybrid_native_bridge.utils.TLSSocketFactoryCompat
import com.kaleyra.video_utils.logging.BaseLogger
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkObject
import io.mockk.unmockkObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class ConfigurationTest {

    @Test
    fun configureLogger() {
        val configuration = KaleyraVideoConfiguration(
            appID = "",
            environment = Environment("test"),
            region = Region("region"),
            logEnabled = true
        )
        val sdkConfiguration = configuration.toSDK({}, {})
        assertEquals(-1, sdkConfiguration.logger!!.target)
        assertEquals(BaseLogger.VERBOSE, sdkConfiguration.logger!!.priority)
    }

    @Test
    fun configureTlsClient() {
        val configuration = KaleyraVideoConfiguration(
            appID = "",
            environment = Environment("test"),
            region = Region("region")
        )
        val sdkConfiguration = configuration.toSDK({}, {})
        assertTrue(sdkConfiguration.httpStack.sslSocketFactory is TLSSocketFactoryCompat)
    }

    @Test
    fun configureTools() {
        val tools = Tools(
            chat = ChatToolConfiguration(AudioCallOptions(Automatic, Audio), videoCallOption = CallOptions(Manual)),
            feedback = true,
            fileShare = true,
            screenShare = ScreenShareToolConfiguration(true, true),
            whiteboard = true
        )
        val configuration = KaleyraVideoConfiguration(
            appID = "appId",
            environment = Environment("test"),
            region = Region("region"),
            tools = tools
        )
        val sdkConfiguration = configuration.toSDK(
            chatActions = { assertEquals(tools.toChatActions(), it) },
            callActions = { assertEquals(tools.toCallActions(), it) }
        )

        assertEquals("appId", sdkConfiguration.appId)
        assertEquals(com.kaleyra.video.configuration.Region.create("region"), sdkConfiguration.region)
        assertEquals(com.kaleyra.video.configuration.Environment.create("test"), sdkConfiguration.environment)
    }
}
