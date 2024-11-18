// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class MainQueueDispatcherTests: UnitTestCase {
    func testPerformsWorkFromTheMainQueueAsynchronously() {
        let exp = expectation(description: "Work performed from the main queue asynchronously")

        DispatchQueue.global().async {
            MainQueueDispatcher.perform {
                exp.fulfill()

                assertThat(DispatchQueue.isMain, isTrue())
            }
        }

        wait(for: [exp], timeout: 2)
    }

    func testPerformsWorkImmediatelyWhenCalledFromTheMainQueue() {
        let completion = CompletionSpy<Void>()

        MainQueueDispatcher.perform(completion.callable)

        assertThat(completion.invocations, hasCount(1))
    }

}
