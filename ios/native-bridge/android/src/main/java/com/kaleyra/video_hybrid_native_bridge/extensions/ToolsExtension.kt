// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.extensions

import com.kaleyra.video.conference.Call
import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_common_ui.ChatUI
import com.kaleyra.video_common_ui.ChatUI.Action.CreateCall
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.Audio
import com.kaleyra.video_hybrid_native_bridge.AudioCallType.AudioUpgradable
import com.kaleyra.video_hybrid_native_bridge.Tools

internal fun Tools.toCallActions(): Set<CallUI.Action> {
    val callActions = CallUI.Action.default.toMutableSet()
    if (this.whiteboard == true) {
        callActions.add(CallUI.Action.OpenWhiteboard.Full)
    }
    if (this.fileShare == true) {
        callActions.add(CallUI.Action.FileShare)
    }

    screenShare.toSDK()?.let {
        callActions.add(it)
    }

    return callActions
}

internal fun Tools.toChatActions(): Set<ChatUI.Action> {
    chat ?: return emptySet()
    val chatActions = mutableSetOf<ChatUI.Action>()
    when (chat.audioCallOption?.type) {
        Audio -> {
            chatActions.add(
                CreateCall(
                    preferredType = Call.PreferredType.audioOnly(),
                    recordingType = chat.audioCallOption.recordingType.toSDK()
                )
            )
        }

        AudioUpgradable -> {
            chatActions.add(
                CreateCall(
                    preferredType = Call.PreferredType.audioUpgradable(),
                    recordingType = chat.audioCallOption.recordingType.toSDK()
                )
            )
        }

        else -> Unit
    }
    if (chat.videoCallOption != null) {
        chatActions.add(
            CreateCall(
                preferredType = Call.PreferredType.audioVideo(),
                recordingType = chat.videoCallOption.recordingType.toSDK()
            )
        )
    }
    return chatActions
}
