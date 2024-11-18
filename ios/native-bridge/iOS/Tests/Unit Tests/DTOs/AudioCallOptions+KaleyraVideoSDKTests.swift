// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

class AudioCallOptions_KaleyraVideoSDKTests: UnitTestCase {

    func testMakeCallOptions() {
        assertThat(AudioCallOptions(recordingType: .automatic, type: .audioUpgradable).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioUpgradable, recording: .automatic)))
        assertThat(AudioCallOptions(recordingType: .manual, type: .audioUpgradable).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioUpgradable, recording: .manual)))
        assertThat(AudioCallOptions(recordingType: RecordingType.none, type: .audioUpgradable).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioUpgradable, recording: .none)))
        assertThat(AudioCallOptions(recordingType: nil, type: .audioUpgradable).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioUpgradable, recording: .none)))
        assertThat(AudioCallOptions(recordingType: .automatic, type: .audio).callOptions,
                   equalTo(KaleyraVideoSDK.CallOptions(type: .audioOnly, recording: .automatic)))
    }
}
