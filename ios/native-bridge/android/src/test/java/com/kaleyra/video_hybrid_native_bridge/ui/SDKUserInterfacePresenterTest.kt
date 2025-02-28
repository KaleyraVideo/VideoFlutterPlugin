// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.ui

import com.kaleyra.video.conference.Call
import com.kaleyra.video.conference.Conference
import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_common_ui.ConferenceUI
import com.kaleyra.video_common_ui.ConversationUI
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.Background
import com.kaleyra.video_hybrid_native_bridge.CallType.Audio
import com.kaleyra.video_hybrid_native_bridge.CallType.AudioUpgradable
import com.kaleyra.video_hybrid_native_bridge.CallType.AudioVideo
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptions
import com.kaleyra.video_hybrid_native_bridge.RecordingType
import com.kaleyra.video_hybrid_native_bridge.configurator.CachedSDKConfigurator
import com.kaleyra.video_hybrid_native_bridge.mock.MockContextContainer
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import com.kaleyra.video.State
import io.mockk.every
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
import kotlinx.coroutines.flow.MutableStateFlow
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class SDKUserInterfacePresenterTest {

    private val contextContainer = MockContextContainer()
    private val sdk = mockk<KaleyraVideo>(relaxed = true)
    private val configurator = mockk<CachedSDKConfigurator>(relaxed = true) {
        every { lastConfiguration?.tools?.feedback } returns true
    }
    private val sdkUserInterfacePresenter =
        SDKUserInterfacePresenter(sdk, contextContainer, configurator)

    @Test
    fun presentAudioCallWithOptions() {
        val conference = mockk<ConferenceUI>(relaxed = true)
        val slot = slot<Conference.CreationOptions.() -> Unit>()
        every { sdk.conference } returns conference
        every {
            conference.call(
                any(),
                capture(slot)
            )
        } returns Result.success(mockk(relaxed = true))
        val options =
            CreateCallOptions(listOf("callee"), Audio, recordingType = RecordingType.Automatic)
        sdkUserInterfacePresenter.startCall(options)

        val defaultOptions = Conference.CreationOptions(
            recordingType = Call.Recording.Type.Automatic,
            callType = Call.Type.audioOnly()
        )
        slot.captured.invoke(defaultOptions)
        assertEquals(Call.Type.audioOnly(), defaultOptions.callType)
        assertEquals(Call.Recording.automatic(), defaultOptions.recordingType)
        verify { conference.call(userIDs = listOf("callee"), any()) }
    }

    @Test
    fun presentAudioUpgradableCallWithOptions() {
        val conference = mockk<ConferenceUI>(relaxed = true)
        val slot = slot<Conference.CreationOptions.() -> Unit>()
        every { sdk.conference } returns conference
        every {
            conference.call(
                any(),
                capture(slot)
            )
        } returns Result.success(mockk(relaxed = true))
        val options =
            CreateCallOptions(listOf("callee"), AudioUpgradable, recordingType = RecordingType.None)
        sdkUserInterfacePresenter.startCall(options)

        val defaultOptions = Conference.CreationOptions(
            recordingType = Call.Recording.Type.Never,
            callType = Call.Type.audioUpgradable()
        )
        slot.captured.invoke(defaultOptions)
        assertEquals(Call.Type.audioUpgradable(), defaultOptions.callType)
        assertEquals(Call.Recording.disabled(), defaultOptions.recordingType)
        verify { conference.call(userIDs = listOf("callee"), any()) }
    }

    @Test
    fun presentAudioVideoCallWithOptions() {
        val conference = mockk<ConferenceUI>(relaxed = true)
        val slot = slot<Conference.CreationOptions.() -> Unit>()
        every { sdk.conference } returns conference
        every {
            conference.call(
                any(),
                capture(slot)
            )
        } returns Result.success(mockk(relaxed = true))
        val options =
            CreateCallOptions(listOf("callee"), AudioVideo, recordingType = RecordingType.Manual)
        sdkUserInterfacePresenter.startCall(options)

        val defaultOptions = Conference.CreationOptions(
            recordingType = Call.Recording.Type.Manual,
            callType = Call.Type.audioVideo()
        )
        slot.captured.invoke(defaultOptions)
        assertEquals(Call.Type.audioVideo(), defaultOptions.callType)
        assertEquals(Call.Recording.manual(), defaultOptions.recordingType)
        verify { conference.call(userIDs = listOf("callee"), any()) }
    }

    @Test
    fun startCallWithFeedback() {
        val conference = mockk<ConferenceUI>(relaxed = true)
        val call = CallUI(mockk(relaxed = true), this::class.java)
        every { sdk.conference } returns conference
        every { conference.call(any(), any()) } returns Result.success(call)
        val options = CreateCallOptions(listOf("callee"), AudioVideo)
        sdkUserInterfacePresenter.startCall(options)

        assertEquals(true, call.withFeedback)
    }

    @Test
    fun presentCallWithUrl() {
        every { sdk.state } returns MutableStateFlow(State.Connecting)
        val conference = mockk<ConferenceUI>(relaxed = true)
        every { sdk.conference } returns conference
        sdkUserInterfacePresenter.startCallUrl("https://url")
        verify { conference.join("https://url") }
    }

    @Test
    fun sdkDisconnected_presentCallWithUrl() {
        every { sdk.state } returns MutableStateFlow(State.Disconnected)
        sdkUserInterfacePresenter.startCallUrl("https://url")
        verify { sdk.connect("https://url") }
    }

    @Test
    fun presentChat() {
        val conversation = mockk<ConversationUI>(relaxed = true)
        every { sdk.conversation } returns conversation
        sdkUserInterfacePresenter.startChat("user2")
        verify { conversation.chat(contextContainer.context, "user2") }
    }

    @Test
    fun changeCurrentCallMode() {
        val mockedCall = mockk<CallUI>(relaxed = true)
        every { sdk.conference.call } returns MutableStateFlow(mockedCall)
        sdkUserInterfacePresenter.setDisplayModeForCurrentCall(Background)
        verify { mockedCall.setDisplayMode(CallUI.DisplayMode.Background) }
    }

}
