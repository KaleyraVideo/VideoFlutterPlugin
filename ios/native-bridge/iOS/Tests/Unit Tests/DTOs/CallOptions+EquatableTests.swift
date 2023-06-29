// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class CallOptions_EquatableTests: UnitTestCase {

    func testEquatable() {
        let sut = CallOptions(recordingType: .manual)
        let same = CallOptions(recordingType: .manual)
        let different = CallOptions(recordingType: .automatic)

        assertThat(sut, equalTo(sut))
        assertThat(sut, equalTo(same))
        assertThat(sut, not(equalTo(different)))
    }
}
