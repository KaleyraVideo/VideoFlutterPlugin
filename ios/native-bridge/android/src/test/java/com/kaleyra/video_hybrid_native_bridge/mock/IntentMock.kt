// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import com.bandyer.android_sdk.intent.BandyerIntent.Builder
import com.bandyer.android_sdk.intent.call.CallIntentBuilder
import com.bandyer.android_sdk.intent.chat.ChatIntentBuilder
import io.mockk.CapturingSlot
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkConstructor
import io.mockk.slot
import io.mockk.unmockkConstructor

sealed class IntentMock {

    object Chat : IntentMock() {

        val participant: CapturingSlot<String> = slot()

        var isChat = false

        override fun mock() {
            super.mock()
            val chatIntentBuilder = mockk<ChatIntentBuilder> {
                every { with(capture(participant)) } returns mockk(relaxed = true)
            }
            every { anyConstructed<Builder>().startWithChat(any()) } answers {
                isChat = true
                chatIntentBuilder
            }
        }
    }

    object Call : IntentMock() {

        var callees: CapturingSlot<ArrayList<String>> = slot()

        val joinUrl: CapturingSlot<String> = slot()

        var isAudio = false

        var isAudioUpgradable = false

        var isAudioVideo = false

        var isJoin = false

        override fun mock() {
            super.mock()
            val callIntentBuilder = mockk<CallIntentBuilder> {
                every { with(capture(callees)) } returns mockk(relaxed = true)
            }
            every { anyConstructed<Builder>().startWithAudioCall(any()) } answers {
                isAudio = true
                callIntentBuilder
            }

            every { anyConstructed<Builder>().startWithAudioUpgradableCall(any()) } answers {
                isAudioUpgradable = true
                callIntentBuilder
            }

            every { anyConstructed<Builder>().startWithAudioVideoCall(any()) } answers {
                isAudioVideo = true
                callIntentBuilder
            }

            every { anyConstructed<Builder>().startFromJoinCallUrl(any(), capture(joinUrl)) } answers {
                isJoin = true
                mockk(relaxed = true)
            }
        }
    }

    open fun mock() {
        mockkConstructor(Builder::class)
    }

    fun unmock() {
        unmockkConstructor(Builder::class)
    }
}
