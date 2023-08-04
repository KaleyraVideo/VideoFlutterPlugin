// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.intent.call.CallRecordingType.AUTOMATIC
import com.bandyer.android_sdk.intent.call.CallRecordingType.MANUAL
import com.bandyer.android_sdk.tool_configuration.screen_share.ScreenShareOptionSet
import com.kaleyra.video_hybrid_native_bridge.AudioCallOptions
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.Audio
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.CallOptions
import com.kaleyra.video_hybrid_native_bridge.ChatToolConfiguration
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptionsProxy
import com.kaleyra.video_hybrid_native_bridge.Environment
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Automatic
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Manual
import com.kaleyra.video_hybrid_native_bridge.Region
import com.kaleyra.video_hybrid_native_bridge.ScreenShareToolConfiguration
import com.kaleyra.video_hybrid_native_bridge.Tools
import com.kaleyra.video_hybrid_native_bridge.mock.MockConfigurableCall
import com.kaleyra.video_hybrid_native_bridge.mock.MockConfigurableChat
import com.kaleyra.video_hybrid_native_bridge.utils.TLSSocketFactoryCompat
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.collaboration_suite_utils.logging.BaseLogger
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
        val sdkConfiguration = configuration.toSDK(CreateCallOptionsProxy())
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
        val sdkConfiguration = configuration.toSDK(CreateCallOptionsProxy())
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
            appID = "",
            environment = Environment("test"),
            region = Region("region"),
            tools = tools
        )
        val sdkConfiguration = configuration.toSDK(CreateCallOptionsProxy())
        val mockConfigurableCall = MockConfigurableCall()
        val mockConfigurableChat = MockConfigurableChat()
        sdkConfiguration.toolsConfiguration.callConfigurationProvider.invoke(mockConfigurableCall)
        sdkConfiguration.toolsConfiguration.chatConfigurationProvider.invoke(mockConfigurableChat)

        assertEquals(true, mockConfigurableChat.hasAudioOnlyCTA())
        assertEquals(false, mockConfigurableChat.hasAudioUpgradableCTA())
        assertEquals(true, mockConfigurableChat.hasAudioVideoCTA())

        assertEquals(true, mockConfigurableChat.hasFeedback())
        assertEquals(true, mockConfigurableChat.hasWhiteboard())
        assertEquals(true, mockConfigurableChat.hasFileShare())

        mockConfigurableChat.assertAudioOnlyRecordingType(AUTOMATIC)
        mockConfigurableChat.assertAudioVideoRecordingType(MANUAL)
        mockConfigurableChat.equalsScreenShareMode(ScreenShareOptionSet.USER_SELECTION)
    }
}
