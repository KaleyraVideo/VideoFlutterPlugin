// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import KaleyraVideoSDK
import Combine
@testable import KaleyraVideoHybridNativeBridge

class CallClientEventsReporterTests: UnitTestCase {

    private let statusChangedEvent = "callModuleStatusChanged"

    private var conference: ConferenceStub!
    private var emitter: EventEmitterSpy!
    private var sut: CallClientEventsReporter!

    override func setUpWithError() throws {
        try super.setUpWithError()

        conference = .init()
        emitter = .init()
        sut = .init(conference: conference, emitter: emitter)
    }

    override func tearDownWithError() throws {
        sut = nil
        emitter = nil
        conference = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testOnClientStartingShouldSendEvent() throws {
        sut.startWithImmediateScheduler()

        conference.state = .connecting

        let event = try unwrap(emitter.sentEvents.first)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, presentAnd(instanceOfAnd(equalTo("connecting"))))
    }

    func testOnClientRunningShouldSendEvent() throws {
        sut.startWithImmediateScheduler()

        conference.state = .connected

        let event = try unwrap(emitter.sentEvents.first)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, presentAnd(instanceOfAnd(equalTo("connected"))))
    }

    func testOnClientStoppedShouldSendEvent() throws {
        sut.startWithImmediateScheduler()

        conference.state = .connected
        conference.state = .disconnected(error: nil)

        let event = try unwrap(emitter.sentEvents.last)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, presentAnd(instanceOfAnd(equalTo("disconnected"))))
    }

    func testOnClientReconnectingShouldSendEvent() throws {
        sut.startWithImmediateScheduler()

        conference.state = .connected
        conference.state = .reconnecting

        let event = try unwrap(emitter.sentEvents.last)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, presentAnd(instanceOfAnd(equalTo("reconnecting"))))
    }

    func testOnClientFailedShouldSendTwoEvents() throws {
        sut.startWithImmediateScheduler()

        let error = anyNSError()
        conference.simulateFailure(error: error)

        assertThat(emitter.sentEvents, hasCount(2))
        let firstEvent = emitter.sentEvents[0]
        assertThat(firstEvent.event, equalTo("callError"))
        assertThat(firstEvent.args, presentAnd(instanceOfAnd(equalTo(error.localizedDescription))))
        let secondEvent = emitter.sentEvents[1]
        assertThat(secondEvent.event, equalTo(statusChangedEvent))
        assertThat(secondEvent.args, presentAnd(instanceOfAnd(equalTo("failed"))))
    }

    func testStopShouldStopListeningForClientEvents() {
        sut.startWithImmediateScheduler()

        sut.stop()
        conference.state = .connected

        assertThat(emitter.sentEvents, empty())
    }

    // TODO: - Add tests for voip credentials
}

private extension CallClientEventsReporter {

    func startWithImmediateScheduler() {
        start(scheduler: ImmediateScheduler.shared)
    }
}
