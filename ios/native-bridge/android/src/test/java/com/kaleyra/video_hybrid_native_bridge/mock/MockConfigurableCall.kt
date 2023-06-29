// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import com.bandyer.android_sdk.call.CallRecordingObserver
import com.bandyer.android_sdk.call.model.CallDirection
import com.bandyer.android_sdk.call.model.CallInfo
import com.bandyer.android_sdk.call.model.CallType
import com.bandyer.android_sdk.intent.call.CallRecordingState
import com.bandyer.android_sdk.intent.call.CallRecordingType
import com.bandyer.android_sdk.intent.call.ConfigurableCall
import com.bandyer.android_sdk.tool_configuration.call.CallConfiguration
import com.bandyer.android_sdk.tool_configuration.call.CustomCallConfiguration
import io.mockk.mockk

class MockConfigurableCall(type: CallType = CallType.AUDIO_ONLY, recordingType: CallRecordingType = CallRecordingType.NONE) : ConfigurableCall {
    override var callConfiguration: CallConfiguration = CustomCallConfiguration()
    override val callInfo: CallInfo = MockCallInfo(type, recordingType)
    override val callRecordingState: CallRecordingState = mockk()
    override fun addCallRecordingObserver(callRecordingObserver: CallRecordingObserver) = Unit
    override fun removeCallRecordingObserver(callRecordingObserver: CallRecordingObserver) = Unit
}

class MockCallInfo(override val type: CallType, override val recordingType: CallRecordingType) : CallInfo {
    override val callId: String = "callId"
    override val callees: Iterable<String> = listOf()
    override val caller: String = "caller"
    override val direction: CallDirection = CallDirection.OUTGOING
}
