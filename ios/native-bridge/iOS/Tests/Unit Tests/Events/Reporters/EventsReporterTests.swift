// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

final class EventsReporterTests: UnitTestCase {

    // MARK: - Start

    func testStartShoulStartCallClientAndChatClientEventReportes() {
        let sut = makeSUT()

        sut.start()

        assertThat(sut.callClientEventReporter, present())
        assertThat(sut.callClientEventReporter?.isRunning, presentAnd(isTrue()))
        assertThat(sut.chatClientEventReporter, present())
        assertThat(sut.chatClientEventReporter?.isRunning, presentAnd(isTrue()))
    }

    func testMultipleStartInvocationShouldCreateAndStartCallAndChatReportersOnlyOnce() throws {
        let sut = makeSUT()

        sut.start()
        let callReporter = try unwrap(sut.callClientEventReporter)
        let chatReporter = try unwrap(sut.chatClientEventReporter)
        sut.start()

        assertThat(sut.callClientEventReporter, presentAnd(sameInstance(callReporter)))
        assertThat(sut.chatClientEventReporter, presentAnd(sameInstance(chatReporter)))
    }

    // MARK: - Stop

    func testStopShoulStopCallClientAndChatClientEventReportes() throws {
        let sut = makeSUT()

        sut.start()
        let callReporter = try unwrap(sut.callClientEventReporter)
        let chatReporter = try unwrap(sut.chatClientEventReporter)
        sut.stop()

        assertThat(callReporter.isRunning, isFalse())
        assertThat(sut.callClientEventReporter, nilValue())
        assertThat(chatReporter.isRunning, isFalse())
        assertThat(sut.chatClientEventReporter, nilValue())
    }

    // MARK: - Helpers

    private func makeSUT() -> EventsReporter {
        EventsReporter(emitter: makeEventEmitterSpy(), sdk: makeSdkDummy())
    }

    private func makeEventEmitterSpy() -> EventEmitterSpy {
        .init()
    }

    private func makeChatClientStub() -> ConversationStub {
        .init()
    }

    private func makeSdkDummy() -> KaleyraVideoSDKProtocolDummy {
        .init()
    }
}


