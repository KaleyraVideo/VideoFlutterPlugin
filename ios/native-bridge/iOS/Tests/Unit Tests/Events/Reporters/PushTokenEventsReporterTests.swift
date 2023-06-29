// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
import PushKit
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class PushTokenEventsReporterTests: UnitTestCase {

    private var emitter: EventEmitterSpy!
    private var sut: PushTokenEventsReporter!
    private var registry: PKPushRegistry!

    override func setUpWithError() throws {
        try super.setUpWithError()

        emitter = .init()
        sut = .init(emitter: emitter)
        registry = .init(queue: nil)
    }

    override func tearDownWithError() throws {
        registry = nil
        sut = nil
        emitter = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testOnPushTokenInvalidatedUpdatedShouldSendEvent() throws {
        sut.pushRegistry(registry, didInvalidatePushTokenFor: .voIP)

        let event = try unwrap(emitter.sentEvents.first)

        assertThat(event.event, equalTo("iOSVoipPushTokenInvalidated"))
    }

    func testOnPushCredentialsUpdatedShouldSendEvent() throws {
        let token = "5b4b68e78c03e2d3b4a7e29e2b7d4429aa497538ac6c8520c6a7c278b5e4047e"
        let credentials = makeCredentials(token: token)

        sut.pushRegistry(registry, didUpdate: credentials, for: .voIP)
        let event = try unwrap(emitter.sentEvents.first)

        assertThat(event.event, equalTo("iOSVoipPushTokenUpdated"))
        assertThat(event.args, presentAnd(instanceOfAnd(equalTo(token))))
    }

    func testLastTokenShouldBeNilByDefault() {
        assertThat(sut.lastToken, nilValue())
    }

    func testLastTokenShouldContainTheLastReceivedVoIPToken() {
        let token = "5b4b68e78c03e2d3b4a7e29e2b7d4429aa497538ac6c8520c6a7c278b5e4047e"
        let credentials = makeCredentials(token: token)

        sut.pushRegistry(registry, didUpdate: credentials, for: .voIP)

        assertThat(sut.lastToken, presentAnd(equalTo(token)))
    }

    func testDidInvalidatePushTokenShouldSetBackToNilLastTokenProperty() {
        let token = "5b4b68e78c03e2d3b4a7e29e2b7d4429aa497538ac6c8520c6a7c278b5e4047e"
        let credentials = makeCredentials(token: token)

        sut.pushRegistry(registry, didUpdate: credentials, for: .voIP)
        sut.pushRegistry(registry, didInvalidatePushTokenFor: .voIP)

        assertThat(sut.lastToken, nilValue())
    }

    // MARK: - Helpers

    private func makeCredentials(token: String) -> PKPushCredentials {
        FakePushCredentials(data: (token as NSString).tokenData())
    }

}
