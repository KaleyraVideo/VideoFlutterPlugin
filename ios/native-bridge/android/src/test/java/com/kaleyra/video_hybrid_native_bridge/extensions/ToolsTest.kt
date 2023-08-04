// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.intent.call.CallRecordingType
import com.bandyer.android_sdk.tool_configuration.screen_share.ScreenShareOptionSet
import com.kaleyra.video_hybrid_native_bridge.AudioCallOptions
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.Audio
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.AudioUpgradable
import com.kaleyra.video_hybrid_native_bridge.CallOptions
import com.kaleyra.video_hybrid_native_bridge.CallType
import com.kaleyra.video_hybrid_native_bridge.ChatToolConfiguration
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptions
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptionsProxy
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Automatic
import com.kaleyra.video_hybrid_native_bridge.RecordingType.Manual
import com.kaleyra.video_hybrid_native_bridge.RecordingType.None
import com.kaleyra.video_hybrid_native_bridge.ScreenShareToolConfiguration
import com.kaleyra.video_hybrid_native_bridge.Tools
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class ToolsTest {

    @Test
    fun screenShareNone() {
        val tools = Tools()
        val callConfiguration = tools.toCallConfiguration(null, CreateCallOptionsProxy())
        assertEquals(null, callConfiguration.capabilitySet.screenShare)
    }

    @Test
    fun screenShareInApp() {
        val tools = Tools(screenShare = ScreenShareToolConfiguration(true))
        val callConfiguration = tools.toCallConfiguration(null, CreateCallOptionsProxy())
        assertEquals(ScreenShareOptionSet.APP_ONLY, callConfiguration.capabilitySet.screenShare!!.optionSet.mode)
    }

    @Test
    fun screenShareWholeDevice() {
        val tools = Tools(screenShare = ScreenShareToolConfiguration(wholeDevice = true))
        val callConfiguration = tools.toCallConfiguration(null, CreateCallOptionsProxy())
        assertEquals(ScreenShareOptionSet.WHOLE_DEVICE, callConfiguration.capabilitySet.screenShare!!.optionSet.mode)
    }

    @Test
    fun screenShareWholeInAppAndWholeDevice() {
        val tools = Tools(screenShare = ScreenShareToolConfiguration(inApp = true, wholeDevice = true))
        val callConfiguration = tools.toCallConfiguration(null, CreateCallOptionsProxy())
        assertEquals(ScreenShareOptionSet.USER_SELECTION, callConfiguration.capabilitySet.screenShare!!.optionSet.mode)
    }

    @Test
    fun fileShare() {
        val tools = Tools(fileShare = true)
        val callConfiguration = tools.toCallConfiguration(null, CreateCallOptionsProxy())
        assertEquals(true, callConfiguration.capabilitySet.fileShare != null)
    }

    @Test
    fun whiteboard() {
        val tools = Tools(whiteboard = true)
        val callConfiguration = tools.toCallConfiguration(null, CreateCallOptionsProxy())
        assertEquals(true, callConfiguration.capabilitySet.whiteboard != null)
    }

    @Test
    fun feedback() {
        val tools = Tools(feedback = true)
        val callConfiguration = tools.toCallConfiguration(null, CreateCallOptionsProxy())
        assertEquals(true, callConfiguration.optionSet.feedbackEnabled)
    }

    @Test
    fun recordingTypeNone() {
        val tools = Tools()
        val creationOptions = CreateCallOptionsProxy(CreateCallOptions(listOf(), CallType.Audio, None))
        val callConfiguration = tools.toCallConfiguration(null, creationOptions)
        assertEquals(CallRecordingType.NONE, callConfiguration.optionSet.callRecordingType)
    }

    @Test
    fun recordingTypeManual() {
        val tools = Tools()
        val creationOptions = CreateCallOptionsProxy(CreateCallOptions(listOf(), CallType.Audio, Manual))
        val callConfiguration = tools.toCallConfiguration(null, creationOptions)
        assertEquals(CallRecordingType.MANUAL, callConfiguration.optionSet.callRecordingType)
    }

    @Test
    fun recordingTypeAutomatic() {
        val tools = Tools()
        val creationOptions = CreateCallOptionsProxy(CreateCallOptions(listOf(), CallType.Audio, Automatic))
        val callConfiguration = tools.toCallConfiguration(null, creationOptions)
        assertEquals(CallRecordingType.AUTOMATIC, callConfiguration.optionSet.callRecordingType)
    }

    @Test
    fun chat() {
        val tools = Tools(chat = ChatToolConfiguration(audioCallOption = AudioCallOptions(type = Audio)))
        val chatConfiguration = tools.toChatConfiguration()!!

        assertEquals(true, chatConfiguration.capabilitySet.audioCallConfiguration != null)
        assertEquals(null, chatConfiguration.capabilitySet.audioUpgradableCallConfiguration)
        assertEquals(null, chatConfiguration.capabilitySet.audioVideoCallConfiguration)
    }

    @Test
    fun allTools() {
        val chatConf = ChatToolConfiguration(audioCallOption = AudioCallOptions(Manual, type = AudioUpgradable), videoCallOption = CallOptions(Automatic))
        val tools = Tools(feedback = true, chat = chatConf, whiteboard = true, fileShare = true, screenShare = ScreenShareToolConfiguration(true, true))

        val chatConfiguration = tools.toChatConfiguration()!!
        val callConfiguration = tools.toCallConfiguration(chatConfiguration, CreateCallOptionsProxy(CreateCallOptions(listOf(), CallType.Audio, Automatic)))

        assertEquals(CallRecordingType.AUTOMATIC, callConfiguration.optionSet.callRecordingType)
        assertEquals(true, callConfiguration.optionSet.feedbackEnabled)
        assertEquals(true, callConfiguration.capabilitySet.whiteboard != null)
        assertEquals(true, callConfiguration.capabilitySet.fileShare != null)
        assertEquals(ScreenShareOptionSet.USER_SELECTION, callConfiguration.capabilitySet.screenShare!!.optionSet.mode)

        assertEquals(CallRecordingType.MANUAL, chatConfiguration.capabilitySet.audioUpgradableCallConfiguration!!.optionSet.callRecordingType)
        assertEquals(true, chatConfiguration.capabilitySet.audioUpgradableCallConfiguration!!.optionSet.feedbackEnabled)
        assertEquals(true, chatConfiguration.capabilitySet.audioUpgradableCallConfiguration!!.capabilitySet.whiteboard != null)
        assertEquals(true, chatConfiguration.capabilitySet.audioUpgradableCallConfiguration!!.capabilitySet.fileShare != null)
        assertEquals(ScreenShareOptionSet.USER_SELECTION, chatConfiguration.capabilitySet.audioUpgradableCallConfiguration!!.capabilitySet.screenShare!!.optionSet.mode)

        assertEquals(CallRecordingType.AUTOMATIC, chatConfiguration.capabilitySet.audioVideoCallConfiguration!!.optionSet.callRecordingType)
        assertEquals(true, chatConfiguration.capabilitySet.audioVideoCallConfiguration!!.optionSet.feedbackEnabled)
        assertEquals(true, chatConfiguration.capabilitySet.audioVideoCallConfiguration!!.capabilitySet.whiteboard != null)
        assertEquals(true, chatConfiguration.capabilitySet.audioVideoCallConfiguration!!.capabilitySet.fileShare != null)
        assertEquals(ScreenShareOptionSet.USER_SELECTION, chatConfiguration.capabilitySet.audioVideoCallConfiguration!!.capabilitySet.screenShare!!.optionSet.mode)
    }

}
