// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class MainQueueRelayTests: UnitTestCase {

    func testDispatchesOperationOnMainQueueWhenCalledFromABackgroundQueue() {
        let actuator = Actuator(completes: .inBackground)
        let sut = MainQueueRelay(actuator)

        let exp = expectation(description: "Operation completion called on main queue")
        sut.job() { res in
            assertThat(Thread.isMainThread, isTrue())
            assertThat(res, equalTo("foobar"))
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func testDispatchesOperationImmediatelyWhenCalledFromTheMainQueue() {
        let actuator = Actuator(completes: .immediately)
        let sut = MainQueueRelay(actuator)

        let completion = CompletionSpy<String>()
        sut.job(completion.callable(_:))

        assertThat(completion.invocations.first, presentAnd(equalTo("foobar")))
    }
}

private protocol JobHandler {

    func job(_ handler: @escaping (String) -> Void )
}

private struct Actuator: JobHandler {

    enum Completion {
        case immediately
        case inBackground
    }
    let completion: Completion

    init(completes completion: Completion) {
        self.completion = completion
    }

    func job(_ handler: @escaping (String) -> Void) {
        switch completion {
            case .immediately:
                handler("foobar")
            case .inBackground:
                DispatchQueue.global().async {
                    handler("foobar")
                }
        }
    }
}

extension MainQueueRelay: JobHandler where Decoratee == Actuator {

    func job(_ completion: @escaping (String) -> Void) {
        decoratee.job { [weak self] res in
            self?.dispatch {
                completion(res)
            }
        }
    }
}
