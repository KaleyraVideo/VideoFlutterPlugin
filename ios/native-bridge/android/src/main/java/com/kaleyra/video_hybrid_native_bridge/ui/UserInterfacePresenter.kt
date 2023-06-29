// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.ui

import com.kaleyra.video_hybrid_native_bridge.CallDisplayMode
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptions

interface UserInterfacePresenter {
    fun startCall(callOptions: CreateCallOptions)
    fun startCallUrl(url: String)
    fun startChat(userId: String)
    fun setDisplayModeForCurrentCall(mode: CallDisplayMode)
}
