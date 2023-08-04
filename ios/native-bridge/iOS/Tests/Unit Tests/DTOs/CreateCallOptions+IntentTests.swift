// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class CreateCallOptions_IntentTests: UnitTestCase {

    func testMakeIntent() {
        let sut = CreateCallOptions(callees: ["alice", "bob"], callType: .audioVideo, recordingType: .automatic)

        let intent = sut.makeStartOutgoingCallIntent()

        assertThat(intent.callees, equalTo(["alice", "bob"]))
        assertThat(intent.options.callType, equalTo(.audioVideo))
        assertThat(intent.options.recordingType, equalTo(.automatic))
    }

}
