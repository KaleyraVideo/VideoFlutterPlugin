// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Bandyer
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class CallTypeTests: UnitTestCase {

    func testBandyerCallType() {
        assertThat(CallType.audio.bandyerType, equalTo(.audioOnly))
        assertThat(CallType.audioUpgradable.bandyerType, equalTo(.audioUpgradable))
        assertThat(CallType.audioVideo.bandyerType, equalTo(.audioVideo))
    }
}
