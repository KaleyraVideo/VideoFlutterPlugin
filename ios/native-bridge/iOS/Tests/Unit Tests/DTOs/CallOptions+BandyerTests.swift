// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class CallOptions_BandyerTests: UnitTestCase {

    func testMakeCallOptions() {
        assertThat(CallOptions(recordingType: .automatic).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioVideo, recordingType: .automatic)))
        assertThat(CallOptions(recordingType: .manual).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioVideo, recordingType: .manual)))
        assertThat(CallOptions(recordingType: RecordingType.none).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioVideo, recordingType: .none)))
        assertThat(CallOptions(recordingType: nil).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioVideo, recordingType: .none)))
    }
}
