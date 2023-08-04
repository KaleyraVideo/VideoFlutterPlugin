// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import android.os.Parcel
import com.bandyer.android_sdk.chat.model.ChatInfo
import com.bandyer.android_sdk.chat.model.ConfigurableChat
import com.bandyer.android_sdk.intent.call.CallRecordingType
import com.bandyer.android_sdk.tool_configuration.chat.CallConfiguration
import com.bandyer.android_sdk.tool_configuration.chat.ChatConfiguration
import com.bandyer.android_sdk.tool_configuration.chat.CustomChatConfiguration

class MockConfigurableChat : ConfigurableChat {
    override var chatConfiguration: ChatConfiguration = CustomChatConfiguration()
    override val chatInfo: ChatInfo = MockChatInfo()

    fun hasAudioOnlyCTA() = chatConfiguration.capabilitySet.audioCallConfiguration != null
    fun hasAudioUpgradableCTA() = chatConfiguration.capabilitySet.audioUpgradableCallConfiguration != null
    fun hasAudioVideoCTA() = chatConfiguration.capabilitySet.audioVideoCallConfiguration != null

    fun hasFeedback() = chatConfiguration.checkForAllCallTypes { optionSet.feedbackEnabled }
    fun hasWhiteboard() = chatConfiguration.checkForAllCallTypes { capabilitySet.whiteboard != null }
    fun hasFileShare() = chatConfiguration.checkForAllCallTypes { capabilitySet.fileShare != null }

    fun assertAudioOnlyRecordingType(recordingType: CallRecordingType) = chatConfiguration.capabilitySet.audioCallConfiguration?.optionSet?.callRecordingType == recordingType
    fun assertAudioUpgradableRecordingType(recordingType: CallRecordingType) = chatConfiguration.capabilitySet.audioUpgradableCallConfiguration?.optionSet?.callRecordingType == recordingType
    fun assertAudioVideoRecordingType(recordingType: CallRecordingType) = chatConfiguration.capabilitySet.audioVideoCallConfiguration?.optionSet?.callRecordingType == recordingType

    fun equalsScreenShareMode(mode: Int) = chatConfiguration.checkForAllCallTypes { capabilitySet.screenShare!!.optionSet.mode == mode }

    private fun ChatConfiguration.checkForAllCallTypes(block: CallConfiguration.() -> Boolean): Boolean {
        val audio = this.capabilitySet.audioCallConfiguration
        val audioUpgradable = this.capabilitySet.audioUpgradableCallConfiguration
        val audioVideo = this.capabilitySet.audioVideoCallConfiguration
        return audio?.let { block.invoke(it) } ?: true && audioUpgradable?.let { block.invoke(it) } ?: true && audioVideo?.let { block.invoke(it) } ?: true
    }
}


class MockChatInfo : ChatInfo {
    override val participants: List<String> = listOf()
    override val author: String = ""
    override val chatId: String = ""

    override fun writeToParcel(parcel: Parcel, flags: Int) = Unit
    override fun describeContents(): Int = 0
}
