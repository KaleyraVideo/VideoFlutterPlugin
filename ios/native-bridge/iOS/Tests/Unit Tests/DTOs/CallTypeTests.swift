// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import KaleyraVideoSDK
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class CallTypeTests: UnitTestCase {

    func testBandyerCallType() {
        assertThat(CallType.audio.bandyerType, equalTo(.audioOnly))
        assertThat(CallType.audioUpgradable.bandyerType, equalTo(.audioUpgradable))
        assertThat(CallType.audioVideo.bandyerType, equalTo(.audioVideo))
    }
}
