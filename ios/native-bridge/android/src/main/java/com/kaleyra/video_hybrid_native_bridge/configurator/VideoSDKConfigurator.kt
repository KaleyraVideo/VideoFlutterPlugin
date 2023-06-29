// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.configurator

import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptionsProxy
import com.kaleyra.video_hybrid_native_bridge.extensions.toSDK
import com.kaleyra.video_hybrid_native_bridge.repository.ConfigurationEntity
import com.kaleyra.video_hybrid_native_bridge.repository.VideoHybridBridgeRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

internal class VideoSDKConfigurator(
    private val sdk: BandyerSDKInstance,
    private val createCallOptionsProxy: CreateCallOptionsProxy,
    private val repository: VideoHybridBridgeRepository,
    private val scope: CoroutineScope
) : CachedSDKConfigurator {

    override var lastConfiguration: KaleyraVideoConfiguration? = null

    override fun configureBridge(configuration: KaleyraVideoConfiguration) {
        scope.launch {
            repository.configurationDao().insert(ConfigurationEntity(configuration))
            sdk.configure(configuration.toSDK(createCallOptionsProxy))
            lastConfiguration = configuration
        }
    }

    override fun reset() {
        scope.launch {
            repository.clearAllTables()
            sdk.reset()
            lastConfiguration = null
        }
    }

    init {
        scope.launch {
            lastConfiguration = repository.configurationDao().configuration?.plugin
        }
    }

}
