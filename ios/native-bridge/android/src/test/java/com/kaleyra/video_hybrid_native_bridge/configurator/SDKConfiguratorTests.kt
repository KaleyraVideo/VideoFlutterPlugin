// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.configurator

import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_common_ui.ChatUI
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
import com.kaleyra.video_hybrid_native_bridge.extensions.toCallActions
import com.kaleyra.video_hybrid_native_bridge.extensions.toChatActions
import com.kaleyra.video_hybrid_native_bridge.mock.MockVideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.repository.ConfigurationEntity
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkObject
import io.mockk.unmockkObject
import io.mockk.verify
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RandomRunner::class)
class SDKConfiguratorTests {

    private val repository = MockVideoHybridBridgeRepository()
    private val sdk = mockk<KaleyraVideo>(relaxed = true)
    private val conf = KaleyraVideoConfiguration(
        appID = "appId",
        environment = Environment("env"),
        region = Region("region"),
        tools = Tools(
            chat = ChatToolConfiguration(
                AudioCallOptions(Automatic, Audio), videoCallOption = CallOptions(Manual)
            ),
            feedback = true,
            fileShare = true,
            screenShare = ScreenShareToolConfiguration(true, true),
            whiteboard = true
        )
    )

    @Test
    fun loadFromRepositoryAtInit() = runTest(CoroutineName("io")) {
        val repository = MockVideoHybridBridgeRepository(configuration = ConfigurationEntity(conf))
        val configurator = VideoSDKConfigurator(sdk, repository, this)
        advanceUntilIdle()
        with(repository.configurationDao) {
            verify(exactly = 1) { configuration }
        }
        assertEquals(conf, configurator.lastConfiguration)
    }

    @Test
    fun configure() = runTest(CoroutineName("io")) {
        mockkObject(KaleyraVideo)
        val conference = ConferenceUI(mockk(relaxed = true), this::class.java)
        val conversation = ConversationUI(mockk(relaxed = true), this::class.java)
        every { sdk.conversation } returns conversation
        every { sdk.conference } returns conference
        val configurator = VideoSDKConfigurator(sdk, repository, this)
        configurator.configureBridge(conf)
        advanceUntilIdle()
        verify { sdk.configure(any()) }
        with(repository.configurationDao) {
            verify { insert(any()) }
        }
        assertEquals(conf, configurator.lastConfiguration)
        assertEquals(conf.tools!!.toCallActions(), sdk.conference.callActions)
        assertEquals(conf.tools!!.toChatActions(), sdk.conversation.chatActions)
        unmockkObject(KaleyraVideo)
    }

    @Test
    fun reset() = runTest(CoroutineName("io")) {
        mockkObject(KaleyraVideo)
        val conference = ConferenceUI(mockk(relaxed = true), this::class.java)
        val conversation = ConversationUI(mockk(relaxed = true), this::class.java)
        every { KaleyraVideo.conversation } returns conversation
        every { KaleyraVideo.conference } returns conference
        val configurator = VideoSDKConfigurator(sdk, repository, this)
        configurator.configureBridge(conf)
        configurator.reset()
        advanceUntilIdle()
        verify { sdk.reset() }
        assertEquals(true, repository.clearAllTables)
        assertEquals(null, configurator.lastConfiguration)
        assertEquals(CallUI.Action.default, KaleyraVideo.conference.callActions)
        assertEquals(ChatUI.Action.default, KaleyraVideo.conversation.chatActions)
        unmockkObject(KaleyraVideo)
    }
}
