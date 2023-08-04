// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.bandyer.android_sdk.intent.call.CallOptions
import com.bandyer.android_sdk.tool_configuration.call.CustomCallConfiguration
import com.bandyer.android_sdk.tool_configuration.chat.CustomChatConfiguration
import com.bandyer.android_sdk.tool_configuration.chat.CustomChatConfiguration.CustomCapabilitySet
import com.bandyer.android_sdk.tool_configuration.file_share.CustomFileShareConfiguration
import com.bandyer.android_sdk.tool_configuration.file_share.FileShareConfiguration
import com.bandyer.android_sdk.tool_configuration.screen_share.CustomScreenShareConfiguration
import com.bandyer.android_sdk.tool_configuration.screen_share.ScreenShareConfiguration
import com.bandyer.android_sdk.tool_configuration.whiteboard.CustomWhiteboardConfiguration
import com.bandyer.android_sdk.tool_configuration.whiteboard.WhiteboardConfiguration
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.Audio
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.AudioUpgradable
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptionsProxy
import com.kaleyra.video_hybrid_native_bridge.RecordingType
import com.kaleyra.video_hybrid_native_bridge.Tools

internal fun Tools.toCallConfiguration(chatConfiguration: CustomChatConfiguration?, createCallOptionsProxy: CreateCallOptionsProxy): CustomCallConfiguration {
    val fileShareConfiguration = CustomFileShareConfiguration().takeIf { fileShare == true }
    val screenShareConfiguration = screenShare(this)
    val whiteboardConfiguration = CustomWhiteboardConfiguration().takeIf { whiteboard == true }
    val feedback = feedback == true

    return CustomCallConfiguration(
        capabilitySet = CustomCallConfiguration.CustomCapabilitySet(
            chatConfiguration,
            fileShareConfiguration,
            screenShareConfiguration,
            whiteboardConfiguration
        ),
        optionSet = callOptions(feedback, createCallOptionsProxy.createCallOptions.recordingType)
    )
}

internal fun Tools.toChatConfiguration(): CustomChatConfiguration? {
    this.chat ?: return null
    val fileShareConfiguration = CustomFileShareConfiguration().takeIf { fileShare == true }
    val screenShareConfiguration = screenShare(this)
    val whiteboardConfiguration = CustomWhiteboardConfiguration().takeIf { whiteboard == true }
    val feedback = feedback == true

    val audioChatCallConfiguration = chatCallConfiguration(
        fileShareConfiguration,
        screenShareConfiguration,
        whiteboardConfiguration,
        feedback,
        chat.audioCallOption?.recordingType
    )

    val audioVideoChatCallConfiguration = chatCallConfiguration(
        fileShareConfiguration,
        screenShareConfiguration,
        whiteboardConfiguration,
        feedback,
        chat.videoCallOption?.recordingType
    )
    return CustomChatConfiguration(CustomCapabilitySet(
        audioCallConfiguration = audioChatCallConfiguration.takeIf { chat.audioCallOption?.type == Audio },
        audioUpgradableCallConfiguration = audioChatCallConfiguration.takeIf { chat.audioCallOption?.type == AudioUpgradable },
        audioVideoCallConfiguration = audioVideoChatCallConfiguration.takeIf { chat.videoCallOption != null }
    ))
}

private fun screenShare(tools: Tools): CustomScreenShareConfiguration? {
    tools.screenShare ?: return null
    val optionSet = tools.screenShare.toSDK() ?: return CustomScreenShareConfiguration()
    return CustomScreenShareConfiguration(optionSet = optionSet)
}

private fun callOptions(feedback: Boolean, recordingType: RecordingType?) = CallOptions(feedbackEnabled = feedback, callRecordingType = recordingType.toSDK())

private fun chatCallCapabilitySet(
    fileShareConfiguration: FileShareConfiguration?,
    screenShareConfiguration: ScreenShareConfiguration?,
    whiteboardConfiguration: WhiteboardConfiguration?
) = CustomCapabilitySet.CustomCallConfiguration.CustomCapabilitySet(
    fileShareConfiguration,
    screenShareConfiguration,
    whiteboardConfiguration
)

private fun chatCallConfiguration(
    fileShareConfiguration: CustomFileShareConfiguration?,
    screenShareConfiguration: CustomScreenShareConfiguration?,
    whiteboardConfiguration: CustomWhiteboardConfiguration?,
    feedback: Boolean,
    recordingType: RecordingType?
) = CustomCapabilitySet.CustomCallConfiguration(
    capabilitySet = chatCallCapabilitySet(fileShareConfiguration, screenShareConfiguration, whiteboardConfiguration),
    optionSet = callOptions(feedback, recordingType)
)
