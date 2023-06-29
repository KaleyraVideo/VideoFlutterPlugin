// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.ui

import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.intent.call.Call
import com.bandyer.android_sdk.intent.call.CallDisplayMode.BACKGROUND
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode.Background
import com.kaleyra.video_hybrid_native_bridge.CallType.Audio
import com.kaleyra.video_hybrid_native_bridge.CallType.AudioUpgradable
import com.kaleyra.video_hybrid_native_bridge.CallType.AudioVideo
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptions
import com.kaleyra.video_hybrid_native_bridge.mock.IntentMock
import com.kaleyra.video_hybrid_native_bridge.mock.MockContextContainer
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(RandomRunner::class)
class SDKUserInterfacePresenterTest{

    private val contextContainer = MockContextContainer()
    private val sdk = mockk<BandyerSDKInstance>(relaxed = true)
    private val sdkUserInterfacePresenter = SDKUserInterfacePresenter(sdk, contextContainer)

    @Test
    fun presentAudioCallWithOptions() {
        IntentMock.Call.mock()
        val options = CreateCallOptions(listOf("callee"), Audio)
        sdkUserInterfacePresenter.startCall(options)
        verify { contextContainer.context.startActivity(any()) }
        assertEquals(arrayListOf("callee"), IntentMock.Call.callees.captured)
        assertEquals(true, IntentMock.Call.isAudio)
    }

    @Test
    fun presentAudioUpgradableCallWithOptions() {
        IntentMock.Call.mock()
        val options = CreateCallOptions(listOf("callee"), AudioUpgradable)
        sdkUserInterfacePresenter.startCall(options)
        verify { contextContainer.context.startActivity(any()) }
        assertEquals(arrayListOf("callee"), IntentMock.Call.callees.captured)
        assertEquals(true, IntentMock.Call.isAudioUpgradable)
    }

    @Test
    fun presentAudioVideoCallWithOptions() {
        IntentMock.Call.mock()
        val options = CreateCallOptions(listOf("callee"), AudioVideo)
        sdkUserInterfacePresenter.startCall(options)
        verify { contextContainer.context.startActivity(any()) }
        assertEquals(arrayListOf("callee"), IntentMock.Call.callees.captured)
        assertEquals(true, IntentMock.Call.isAudioVideo)
    }

    @Test
    fun presentCallWithUrl() {
        IntentMock.Call.mock()
        sdkUserInterfacePresenter.startCallUrl("https://url")
        verify { contextContainer.context.startActivity(any()) }
        assertEquals("https://url", IntentMock.Call.joinUrl.captured)
        assertEquals(true, IntentMock.Call.isJoin)
    }

    @Test
    fun presentChat() {
        IntentMock.Chat.mock()
        sdkUserInterfacePresenter.startChat("user2")
        verify { contextContainer.context.startActivity(any()) }
        assertEquals("user2", IntentMock.Chat.participant.captured)
        assertEquals(true, IntentMock.Chat.isChat)
    }

    @Test
    fun changeCurrentCallMode() {
        val mockedCall = mockk<Call>()
        every { sdk.callModule!!.ongoingCall } returns mockedCall
        sdkUserInterfacePresenter.setDisplayModeForCurrentCall(Background)
        verify { sdk.callModule?.setDisplayMode(mockedCall, BACKGROUND) }
    }

}
