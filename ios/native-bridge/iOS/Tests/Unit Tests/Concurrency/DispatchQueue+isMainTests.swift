// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class DispatchQueue_isMainTests: UnitTestCase {

    func testIsMainShouldReturnTrueWhenRunningOnMainQueue() {
        assertThat(DispatchQueue.isMain, isTrue())
    }

    func testIsMainShouldReturnFalseWhenRunningOnAnotherQueue() {
        let expectation = expectation(description: "")

        DispatchQueue.global().async {
            assertThat(DispatchQueue.isMain, isFalse())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
}
