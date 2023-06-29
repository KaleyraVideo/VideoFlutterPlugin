// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class CallClientEventsReporterTests: UnitTestCase {

    private let statusChangedEvent = "callModuleStatusChanged"

    private var client: CallClientStub!
    private var emitter: EventEmitterSpy!
    private var sut: CallClientEventsReporter!

    override func setUpWithError() throws {
        try super.setUpWithError()

        client = .init()
        emitter = .init()
        sut = .init(client: client, emitter: emitter)
    }

    override func tearDownWithError() throws {
        sut = nil
        emitter = nil
        client = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testStartTwiceShouldSubscribeAsClientObserverOnlyOnce() {
        sut.start()

        sut.start()

        assertThat(client.clientObservers(), equalTo(1))
    }

    func testOnClientStartingShouldSendEvent() throws {
        sut.start()

        client.state = .starting

        let event = try unwrap(emitter.sentEvents.first)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, instanceOfAnd(equalTo("connecting")))
    }

    func testOnClientRunningShouldSendEvent() throws {
        sut.start()

        client.state = .running

        let event = try unwrap(emitter.sentEvents.first)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, instanceOfAnd(equalTo("ready")))
    }

    func testOnClientStoppedShouldSendEvent() throws {
        sut.start()

        client.state = .running
        client.state = .stopped

        let event = try unwrap(emitter.sentEvents.last)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, instanceOfAnd(equalTo("stopped")))
    }

    func testOnClientPausedShouldSendEvent() throws {
        sut.start()

        client.state = .running
        client.state = .paused

        let event = try unwrap(emitter.sentEvents.last)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, instanceOfAnd(equalTo("paused")))
    }

    func testOnClientReconnectingShouldSendEvent() throws {
        sut.start()

        client.state = .running
        client.state = .reconnecting

        let event = try unwrap(emitter.sentEvents.last)
        assertThat(event.event, equalTo(statusChangedEvent))
        assertThat(event.args, instanceOfAnd(equalTo("reconnecting")))
    }

    func testOnClientFailedShouldSendTwoEvents() throws {
        sut.start()

        let error = anyNSError()
        client.simulateFailure(error: error)

        assertThat(emitter.sentEvents, hasCount(2))
        let firstEvent = emitter.sentEvents[0]
        assertThat(firstEvent.event, equalTo("callError"))
        assertThat(firstEvent.args, instanceOfAnd(equalTo(error.localizedDescription)))
        let secondEvent = emitter.sentEvents[1]
        assertThat(secondEvent.event, equalTo(statusChangedEvent))
        assertThat(secondEvent.args, instanceOfAnd(equalTo("failed")))
    }

    func testStopShouldStopListeningForClientEvents() {
        sut.start()

        sut.stop()
        client.state = .running

        assertThat(emitter.sentEvents, empty())
    }
}
