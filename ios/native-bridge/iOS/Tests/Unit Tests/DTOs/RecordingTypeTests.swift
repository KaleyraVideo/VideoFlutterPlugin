// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class RecordingTypeTests: UnitTestCase {

    func testBandyerRecordingType() {
        assertThat(RecordingType.automatic.callRecordingType, equalTo(.automatic))
        assertThat(RecordingType.manual.callRecordingType, equalTo(.manual))
        assertThat(RecordingType.none.callRecordingType, equalTo(.none))
    }

}
