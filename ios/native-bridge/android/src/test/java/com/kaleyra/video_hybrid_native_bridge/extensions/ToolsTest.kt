// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video.conference.Call
import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_common_ui.ChatUI
import com.kaleyra.video_common_ui.ChatUI.Action.CreateCall
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
        val callActions = tools.toCallActions()
        val expected = CallUI.Action.default.toMutableSet()
        assertEquals(expected, callActions)
    }

    @Test
    fun screenShareInApp() {
        val tools = Tools(screenShare = ScreenShareToolConfiguration(true))
        val callActions = tools.toCallActions()
        val expected = CallUI.Action.default.toMutableSet() + CallUI.Action.ScreenShare
        assertEquals(expected, callActions)
    }

    @Test
    fun screenShareWholeDevice() {
        val tools = Tools(screenShare = ScreenShareToolConfiguration(wholeDevice = true))
        val callActions = tools.toCallActions()
        val expected = CallUI.Action.default.toMutableSet() + CallUI.Action.ScreenShare
        assertEquals(expected, callActions)
    }

    @Test
    fun screenShareWholeInAppAndWholeDevice() {
        val tools = Tools(screenShare = ScreenShareToolConfiguration(inApp = true, wholeDevice = true))
        val callActions = tools.toCallActions()
        val expected = CallUI.Action.default.toMutableSet() + CallUI.Action.ScreenShare
        assertEquals(expected, callActions)
    }

    @Test
    fun fileShare() {
        val tools = Tools(fileShare = true)
        val callActions = tools.toCallActions()
        val expected = CallUI.Action.default.toMutableSet() + CallUI.Action.FileShare
        assertEquals(expected, callActions)
    }

    @Test
    fun whiteboard() {
        val tools = Tools(whiteboard = true)
        val callActions = tools.toCallActions()
        val expected = CallUI.Action.default.toMutableSet() + CallUI.Action.OpenWhiteboard.Full
        assertEquals(expected, callActions)
    }

    @Test
    fun chat() {
        val tools = Tools(chat = ChatToolConfiguration(audioCallOption = AudioCallOptions(type = Audio)))
        val chatActions = tools.toChatActions()

        assertEquals(setOf(CreateCall(preferredType = Call.PreferredType.audioOnly())), chatActions)
    }

    @Test
    fun allTools() {
        val chatConf = ChatToolConfiguration(audioCallOption = AudioCallOptions(Manual, type = AudioUpgradable), videoCallOption = CallOptions(Automatic))
        val tools = Tools(feedback = true, chat = chatConf, whiteboard = true, fileShare = true, screenShare = ScreenShareToolConfiguration(true, true))

        // TODO add test for recording on chat
        val chatActions = tools.toChatActions()
        val callActions = tools.toCallActions()

        assertEquals(true, callActions.firstOrNull { it == CallUI.Action.OpenWhiteboard.Full } != null)
        assertEquals(true, callActions.firstOrNull { it == CallUI.Action.FileShare } != null)
        assertEquals(true, callActions.firstOrNull { it == CallUI.Action.ScreenShare } != null)

        assertEquals(
            setOf(
                CreateCall(preferredType = Call.PreferredType.audioUpgradable()),
                CreateCall(preferredType = Call.PreferredType.audioVideo()),
            ),
            chatActions
        )
    }

}
