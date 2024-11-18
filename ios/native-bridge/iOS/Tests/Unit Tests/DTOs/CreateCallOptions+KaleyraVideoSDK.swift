// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

class CreateCallOptions_KaleyraVideoSDKTests: UnitTestCase {

    func testMakeIntent() {
        let sut = CreateCallOptions(callees: ["alice", "bob"], callType: .audioVideo, recordingType: .automatic)

        let options = sut.makeCallOptions()

        assertThat(options.type, equalTo(.audioVideo))
        assertThat(options.recording, equalTo(.automatic))
    }

}
