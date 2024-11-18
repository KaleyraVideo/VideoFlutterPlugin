// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

final class CallOptions_KaleyraVideoSDKTests: UnitTestCase {

    func testMakeCallOptions() {
        assertThat(CallOptions(recordingType: .automatic).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioVideo, recording: .automatic)))
        assertThat(CallOptions(recordingType: .manual).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioVideo, recording: .manual)))
        assertThat(CallOptions(recordingType: RecordingType.none).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioVideo, recording: .none)))
        assertThat(CallOptions(recordingType: nil).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioVideo, recording: .none)))
    }
}
