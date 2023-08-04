// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class AudioCallOptions_EquatableTests: UnitTestCase {

    func testEquatable() {
        let sut = AudioCallOptions(recordingType: .manual, type: .audio)
        let same = AudioCallOptions(recordingType: .manual, type: .audio)
        let differentRecordingType = AudioCallOptions(recordingType: .automatic, type: .audio)
        let differentCallType = AudioCallOptions(recordingType: .manual, type: .audioUpgradable)

        assertThat(sut, equalTo(sut))
        assertThat(sut, equalTo(same))
        assertThat(sut, not(equalTo(differentRecordingType)))
        assertThat(sut, not(equalTo(differentCallType)))
    }
}
