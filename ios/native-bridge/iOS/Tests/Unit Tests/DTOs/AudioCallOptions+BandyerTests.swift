// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class AudioCallOptions_BandyerTests: UnitTestCase {

    func testMakeCallOptions() {
        assertThat(AudioCallOptions(recordingType: .automatic, type: .audioUpgradable).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioUpgradable, recordingType: .automatic)))
        assertThat(AudioCallOptions(recordingType: .manual, type: .audioUpgradable).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioUpgradable, recordingType: .manual)))
        assertThat(AudioCallOptions(recordingType: RecordingType.none, type: .audioUpgradable).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioUpgradable, recordingType: .none)))
        assertThat(AudioCallOptions(recordingType: nil, type: .audioUpgradable).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioUpgradable, recordingType: .none)))
        assertThat(AudioCallOptions(recordingType: .automatic, type: .audio).callOptions,
                   equalTo(Bandyer.CallOptions(callType: .audioOnly, recordingType: .automatic)))
    }
}
