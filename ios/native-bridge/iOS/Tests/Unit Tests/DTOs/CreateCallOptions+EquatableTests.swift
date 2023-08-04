// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class CreateCallOptions_EquatableTests: UnitTestCase {

    func testEquatable() {
        let sut = CreateCallOptions(callees: ["user_id"], callType: .audioVideo, recordingType: .manual)
        let same = CreateCallOptions(callees: ["user_id"], callType: .audioVideo, recordingType: .manual)
        let differentCallees = CreateCallOptions(callees: ["user_id", "other_user"], callType: .audioVideo, recordingType: .manual)
        let differentCallType = CreateCallOptions(callees: ["user_id"], callType: .audioUpgradable, recordingType: .manual)
        let differentRecording = CreateCallOptions(callees: ["user_id"], callType: .audioVideo, recordingType: .automatic)

        assertThat(sut, equalTo(sut))
        assertThat(sut, equalTo(same))
        assertThat(sut, not(equalTo(differentCallees)))
        assertThat(sut, not(equalTo(differentCallType)))
        assertThat(sut, not(equalTo(differentRecording)))
    }
}

