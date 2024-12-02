// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.ui

import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode
import com.kaleyra.video_hybrid_native_bridge.ContextContainer
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptions
import com.kaleyra.video_hybrid_native_bridge.configurator.CachedSDKConfigurator
import com.kaleyra.video_hybrid_native_bridge.extensions.toSDK
import com.kaleyra.video.State

internal class SDKUserInterfacePresenter(
    private val sdk: KaleyraVideo,
    private val contextContainer: ContextContainer,
    private val configurator: CachedSDKConfigurator
) : UserInterfacePresenter {

    private val context
        get() = contextContainer.context

    override fun startCall(callOptions: CreateCallOptions) {
        sdk.conference.call(
            userIDs = callOptions.callees,
            options = {
                recordingType = callOptions.recordingType.toSDK()
                preferredType = callOptions.callType.toSDK()
            }
        ).onSuccess {
            val withFeedback = configurator.lastConfiguration?.tools?.feedback == true
            it.withFeedback = withFeedback
        }
    }

    override fun startCallUrl(url: String) {
        if (sdk.state.value == State.Disconnected) {
            sdk.connect(url)
        }
        sdk.conference.joinUrl(url)
    }

    override fun startChat(userId: String) {
        sdk.conversation.chat(context, userId)
    }

    override fun setDisplayModeForCurrentCall(mode: CallDisplayMode) {
        val ongoingCall = sdk.conference.call.replayCache.firstOrNull() ?: return
        ongoingCall.setDisplayMode(mode.toSDK())
    }
}
