// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class UserInterfacePresenter_MainQueueRelayTests: UnitTestCase {

    private var spy: UserInterfacePresenterSpy!
    private var sut: UserInterfacePresenter!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        spy = makeUserInterfacePresenterSpy()
        sut = MainQueueRelay(spy)
    }

    override func tearDownWithError() throws {
        sut = nil
        spy = nil

        try super.tearDownWithError()
    }

    // MARK: - Configure

    func testConfigureShouldFrorwardInvocationToDecoratee() {
        let config = makeUserInterfacePresenterConfiguration()

        sut.configure(with: config)

        assertThat(spy.configureInvocations, equalTo([config]))
    }

    func testConfigureShouldFrorwardInvocationToDecorateeOnCurrentQueue() {
        let exp = expectation(description: "Performing work async on background queue")

        spy.onConfigure = {
            exp.fulfill()
            assertThat(Thread.isMainThread, isFalse())
        }

        DispatchQueue.global(qos: .background).async {
            self.sut.configure(with: self.makeUserInterfacePresenterConfiguration())
        }

        wait(for: [exp], timeout: 5.0)
    }

    // MARK: - Present Call

    func testPresentCallWithOptionsShouldFrorwardInvocationToDecoratee() {
        let options = makeCreateCallOptions()

        sut.presentCall(options)

        assertThat(spy.presentCallWithOptionsInvocations, equalTo([options]))
    }

    func testPresentCallWithOptionsShouldFrorwardInvocationToDecorateeOnMainQueue() {
        let exp = expectation(description: "Performing work async on background queue")

        spy.onPresentCallWithOptions = {
            exp.fulfill()

            assertThat(Thread.isMainThread, isTrue())
        }

        DispatchQueue.global(qos: .background).async {
            self.sut.presentCall(self.makeCreateCallOptions())
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testPresentCallWithURLShouldFrorwardInvocationToDecoratee() {
        let url = makeAnyURL()

        sut.presentCall(url)

        assertThat(spy.presentCallWithURLInvocations, equalTo([url]))
    }

    func testPresentCallWithURLShouldFrorwardInvocationToDecorateeOnMainQueue() {
        let exp = expectation(description: "Performing work async on background queue")

        spy.onPresentCallWithURL = {
            exp.fulfill()

            assertThat(Thread.isMainThread, isTrue())
        }

        DispatchQueue.global(qos: .background).async {
            self.sut.presentCall(self.makeAnyURL())
        }

        wait(for: [exp], timeout: 5.0)
    }

    // MARK: - Present Chat

    func testPresentChatShouldFrorwardInvocationToDecoratee() {
        sut.presentChat(with: "user_id")

        assertThat(spy.presentChatInvocations, equalTo(["user_id"]))
    }

    func testPresentChatShouldFrorwardInvocationToDecorateeOnMainQueue() {
        let exp = expectation(description: "Performing work async on background queue")

        spy.onPresentChat = {
            exp.fulfill()

            assertThat(Thread.isMainThread, isTrue())
        }

        DispatchQueue.global(qos: .background).async {
            self.sut.presentChat(with: "user_id")
        }

        wait(for: [exp], timeout: 5.0)
    }

    // MARK: - Helpers

    private func makeUserInterfacePresenterSpy() -> UserInterfacePresenterSpy {
        .init()
    }

    private func makeUserInterfacePresenterConfiguration() -> UserInterfacePresenterConfiguration {
        .init(showsFeedbackWhenCallEnds: false, chatAudioButtonConf: .disabled, chatVideoButtonConf: .disabled)
    }

    private func makeCreateCallOptions() -> CreateCallOptions {
        .init(callees: ["user_id"], callType: .audio, recordingType: .manual)
    }

    private func makeAnyURL() -> URL {
        .init(string: "https://www.kaleyra.com")!
    }
}
