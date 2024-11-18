// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.configurator

import com.kaleyra.video_common_ui.CallUI
import com.kaleyra.video_common_ui.ChatUI
import com.kaleyra.video_common_ui.KaleyraVideo
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.extensions.toSDK
import com.kaleyra.video_hybrid_native_bridge.repository.ConfigurationEntity
import com.kaleyra.video_hybrid_native_bridge.repository.VideoHybridBridgeRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

internal class VideoSDKConfigurator(
    private val sdk: KaleyraVideo,
    private val repository: VideoHybridBridgeRepository,
    private val scope: CoroutineScope
) : CachedSDKConfigurator {

    override var lastConfiguration: KaleyraVideoConfiguration? = null

    override fun configureBridge(configuration: KaleyraVideoConfiguration) {
        scope.launch {
            repository.configurationDao().insert(ConfigurationEntity(configuration))
            sdk.configure(
                configuration.toSDK(
                    callActions = { KaleyraVideo.conference.callActions = it },
                    chatActions = { KaleyraVideo.conversation.chatActions = it }
                )
            )
            lastConfiguration = configuration
        }
    }

    override fun reset() {
        scope.launch {
            repository.clearAllTables()
            sdk.reset()
            KaleyraVideo.conference.callActions = CallUI.Action.default
            KaleyraVideo.conversation.chatActions = ChatUI.Action.default
            lastConfiguration = null
        }
    }

    init {
        scope.launch {
            lastConfiguration = repository.configurationDao().configuration?.plugin
        }
    }

}
