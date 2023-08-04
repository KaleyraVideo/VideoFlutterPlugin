// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.ui

import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.bandyer.android_sdk.intent.BandyerIntent
import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode
import com.kaleyra.video_hybrid_native_bridge.CallType.Audio
import com.kaleyra.video_hybrid_native_bridge.CallType.AudioUpgradable
import com.kaleyra.video_hybrid_native_bridge.CallType.AudioVideo
import com.kaleyra.video_hybrid_native_bridge.ContextContainer
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptions
import com.kaleyra.video_hybrid_native_bridge.extensions.toSDK

internal class SDKUserInterfacePresenter(
    private val sdk: BandyerSDKInstance,
    private val contextContainer: ContextContainer
) : UserInterfacePresenter {

    private val context
        get() = contextContainer.context

    override fun startCall(callOptions: CreateCallOptions) {
        val bandyerCallIntent = BandyerIntent.Builder().let {
            when (callOptions.callType) {
                Audio           -> it.startWithAudioCall(context)
                AudioUpgradable -> it.startWithAudioUpgradableCall(context)
                AudioVideo      -> it.startWithAudioVideoCall(context)
            }.with(ArrayList(callOptions.callees)).build()
        }
        context.startActivity(bandyerCallIntent)
    }

    override fun startCallUrl(url: String) {
        val bandyerCallIntent = BandyerIntent.Builder().startFromJoinCallUrl(context, url).build()
        context.startActivity(bandyerCallIntent)
    }

    override fun startChat(userId: String) {
        val bandyerCallIntent = BandyerIntent.Builder().startWithChat(context).with(userId).build()
        context.startActivity(bandyerCallIntent)
    }

    override fun setDisplayModeForCurrentCall(mode: CallDisplayMode) {
        val ongoingCall = sdk.callModule?.ongoingCall ?: return
        sdk.callModule?.setDisplayMode(ongoingCall, mode.toSDK())
    }
}
