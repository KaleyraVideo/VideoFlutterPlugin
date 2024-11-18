// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

final class KaleyraVideoSDKUserInterfacePresenterTests: UnitTestCase {

    private var sdkSpy: KaleyraVideoSDKProtocolSpy!
    private var viewControllerPresenterSpy: ViewControllerPresenterSpy!
    private var callWindowSpy: CallWindowSpy!
    private var sut: KaleyraVideoSDKUserInterfacePresenter!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        sdkSpy = makeBandyerSDKProtocolSpy()
        viewControllerPresenterSpy = makeViewControllerPresenterSpy()
        callWindowSpy = makeCallWindowSpy()
        sut = makeSUT(sdk: sdkSpy, viewControllerPresenter: viewControllerPresenterSpy, callWindow: callWindowSpy)
        try KaleyraVideo.instance.configure(.init(appID: "app_id", region: .europe, environment: .sandbox))
    }

    override func tearDownWithError() throws {
        sut = nil
        sdkSpy = nil
        viewControllerPresenterSpy = nil
        KaleyraVideo.instance.reset()

        try super.tearDownWithError()
    }

    // MARK: - Configure

    func testConfigureShouldSetupNotificationCoordinator() {
        sut.configure(with: makeUserInterfacePresenterConfiguration())

        assertThat(sdkSpy.conversationStub.notificationsSpy.delegate, presentAnd(instanceOfAnd(sameInstance(sut))))
        assertThat(sdkSpy.conversationStub.notificationsSpy.startInvocations, hasCount(1))
    }

    // MARK: - Present Chat UI

    func testPresentChatShouldPresentAChannelViewControllerOnViewControllerPresenter() {
        sut.presentChat(with: "user_id")

        assert(presenter: viewControllerPresenterSpy, hasPresented: ChatViewController.self)
    }

    func testPresentChatShouldConfigureChannelViewController() throws {
        sut.presentChat(with: "user_id")
        let channelVC = try unwrap(viewControllerPresenterSpy.presentInvocations.first?.viewController as? ChatViewController)

        assertThat(channelVC.delegate, presentAnd(instanceOfAnd(equalTo(sut))))
        assertThat(channelVC.configuration, present())
    }

    func testChannelViewControllerDidFinishShouldDismissUsingViewControllerPresenter() {
        let controller = makeChatViewController()

        sut.chatViewControllerDidFinish(controller)

        assertThat(viewControllerPresenterSpy.dismissInvocations, hasCount(1))
        assertThat(viewControllerPresenterSpy.dismissInvocations.first?.viewController, presentAnd(instanceOfAnd(equalTo(controller))))
        assertThat(viewControllerPresenterSpy.dismissInvocations.first?.animated, presentAnd(isTrue()))
    }

    func testPresentingChatWhileViewControllerPresenterIsAlreadyPresentingShouldInvokeDismissAll() {
        viewControllerPresenterSpy.mockIsPresenting()
        sut.presentChat(with: "user_id")

        assertThat(viewControllerPresenterSpy.dismissAllInvocations, hasCount(1))
        assertThat(viewControllerPresenterSpy.dismissAllInvocations.first?.animated, presentAnd(isTrue()))
        assertThat(viewControllerPresenterSpy.dismissAllInvocations.first?.completion, present())
    }

    func testDismissAllCompletionShoulPresentChat() throws {
        viewControllerPresenterSpy.mockIsPresenting()
        sut.presentChat(with: "user_id")
        let completion = try unwrap(viewControllerPresenterSpy.dismissAllInvocations.first?.completion)
        completion()

        assert(presenter: viewControllerPresenterSpy, hasPresented: ChatViewController.self)
    }

    // MARK: - Present Call UI

    func testPresentCallShouldCreateTheCallOnConferenceObject() {
        let options = makeCreateCallOptions(callees: ["user_id", "other_user_id"],
                                            callType: .audioUpgradable,
                                            recordingType: .manual)

        sut.presentCall(options)

        assertThat(sdkSpy.conferenceStub.callInvocations, hasCount(1))
        assertThat(sdkSpy.conferenceStub.callInvocations.first?.callees, presentAnd(equalTo(["user_id", "other_user_id"])))
        assertThat(sdkSpy.conferenceStub.callInvocations.first?.options.type, presentAnd(equalTo(.audioUpgradable)))
        assertThat(sdkSpy.conferenceStub.callInvocations.first?.options.recording, presentAnd(equalTo(.manual)))
    }

    func testPresentCallFromUrlShouldCreateTheCallOnConferenceObject() throws {
        let url = try URL.fromString("https://www.kaleyra.com")

        sut.presentCall(url)
        assertThat(sdkSpy.conferenceStub.joinInvocations, hasCount(1))
        assertThat(sdkSpy.conferenceStub.joinInvocations.first?.url, presentAnd(equalTo(URL(string: "https://www.kaleyra.com"))))
    }

    func testChannelViewControllerDidTapAudioCallWithUsersShouldNotPresentCallViewControllerIfDisabledInConfig() {
        let config = makeUserInterfacePresenterConfiguration(chatHasAudioButton: false)

        sut.configure(with: config)
        sut.chatViewControllerDidTapAudioCallButton(makeChatViewController())

        assertThat(sdkSpy.conferenceStub.callInvocations, hasCount(0))
    }

    func testChannelViewControllerDidTapAudioCallWithUsersShouldPresentCallWiewController() {
        let config = makeUserInterfacePresenterConfiguration(chatHasAudioButton: true)

        sut.configure(with: config)
        sut.chatViewControllerDidTapAudioCallButton(makeChatViewController())

        assertThat(sdkSpy.conferenceStub.callInvocations, hasCount(1))
        assertThat(sdkSpy.conferenceStub.callInvocations.first?.options.type, presentAnd(equalTo(.audioUpgradable)))
    }

    func testChannelViewControllerDidTapVideoCallWithWithUsersShouldNotPresentCallViewControllerIfDisabledInConfig() {
        let config = makeUserInterfacePresenterConfiguration(chatHasVideoButton: false)

        sut.configure(with: config)
        sut.chatViewControllerDidTapVideoCallButton(makeChatViewController())

        assertThat(sdkSpy.conferenceStub.callInvocations, hasCount(0))
    }

    func testChannelViewControllerDidTapVideoCallWithUsersShouldPresentCallWiewController() {
        let config = makeUserInterfacePresenterConfiguration(chatHasVideoButton: true)

        sut.configure(with: config)
        sut.chatViewControllerDidTapVideoCallButton(makeChatViewController())

        assertThat(sdkSpy.conferenceStub.callInvocations, hasCount(1))
        assertThat(sdkSpy.conferenceStub.callInvocations.first?.options.type, presentAnd(equalTo(.audioVideo)))
    }

    // MARK: - Helpers

    private func makeSUT(sdk: KaleyraVideoSDKProtocol, viewControllerPresenter: ViewControllerPresenter, callWindow: CallWindowProtocol) -> KaleyraVideoSDKUserInterfacePresenter {
        .init(sdk: sdk, viewControllerPresenter: viewControllerPresenter, callWindow: callWindow)
    }

    private func makeBandyerSDKProtocolSpy() -> KaleyraVideoSDKProtocolSpy {
        .init()
    }

    private func makeViewControllerPresenterSpy() -> ViewControllerPresenterSpy {
        .init()
    }

    private func makeCallWindowSpy() -> CallWindowSpy {
        .init()
    }

    private func makeUserInterfacePresenterConfiguration(showsFeedbackWhenCallEnds: Bool = false,
                                                         chatHasAudioButton: Bool = false,
                                                         chatHasVideoButton: Bool = false) -> UserInterfacePresenterConfiguration {
        makeUserInterfacePresenterConfiguration(showsFeedbackWhenCallEnds: showsFeedbackWhenCallEnds,
                                                chatAudioButtonConf: chatHasAudioButton ? .enabled(makeAudioCallOptions()) : .disabled,
                                                chatVideoButtonConf: chatHasVideoButton ? .enabled(makeCallOptions()) : .disabled)
    }

    private func makeUserInterfacePresenterConfiguration(showsFeedbackWhenCallEnds: Bool,
                                                         chatAudioButtonConf: UserInterfacePresenterConfiguration.ChatAudioButtonConfiguration,
                                                         chatVideoButtonConf: UserInterfacePresenterConfiguration.ChatVideoButtonConfiguration) -> UserInterfacePresenterConfiguration {
        .init(showsFeedbackWhenCallEnds: showsFeedbackWhenCallEnds,
              chatAudioButtonConf: chatAudioButtonConf,
              chatVideoButtonConf: chatVideoButtonConf)
    }

    private func makeAudioCallOptions() -> KaleyraVideoHybridNativeBridge.AudioCallOptions {
        .init(recordingType: .manual, type: .audioUpgradable)
    }

    private func makeCallOptions() -> KaleyraVideoHybridNativeBridge.CallOptions {
        .init(recordingType: .manual)
    }

    private func makeCreateCallOptions(callees: [String] = ["user_id"],
                                       callType: KaleyraVideoHybridNativeBridge.CallType = .audioVideo,
                                       recordingType: KaleyraVideoHybridNativeBridge.RecordingType = .none) -> CreateCallOptions {
        .init(callees: callees, callType: callType, recordingType: recordingType)
    }

    private func makeCall() -> CallDummy {
        .init()
    }

    private func makeCallWindow() -> CallWindow {
        .init()
    }

    private func makeOpenChatIntent(userID: String = "user_id") -> ChatViewController.Intent {
        .participant(id: userID)
    }

    private func makeChatViewController() -> ChatViewController {
        .init(intent: .participant(id: "user_id"), configuration: .init())
    }

    // MARK: - Assertions

    private func assert<T: UIViewController>(presenter: ViewControllerPresenterSpy, hasPresented type: T.Type) {
        assertThat(presenter.presentInvocations, hasCount(1))
        assertThat(presenter.presentInvocations.first?.viewController, presentAnd(instanceOf(type)))
        assertThat(presenter.presentInvocations.first?.animated, presentAnd(isTrue()))
    }
}

private class ViewControllerPresenterSpy: ViewControllerPresenter {

    private(set) var isPresenting: Bool = false

    private(set) var presentInvocations = [(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)]()
    private(set) var displayAlertInvocations = [(title: String, message: String, dismissButtonText: String)]()
    private(set) var dismissInvocations = [(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)]()
    private(set) var dismissAllInvocations = [(animated: Bool, completion: (() -> Void)?)]()

    func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        isPresenting = true
        presentInvocations.append((viewController: viewController, animated: flag, completion: completion))
    }

    func displayAlert(title: String, message: String, dismissButtonText: String) {
        isPresenting = true
        displayAlertInvocations.append((title: title, message: message, dismissButtonText: dismissButtonText))
    }

    func dismiss(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        isPresenting = false
        dismissInvocations.append((viewController: viewController, animated: flag, completion: completion))
    }

    func dismissAll(animated flag: Bool, completion: (() -> Void)?) {
        isPresenting = false
        dismissAllInvocations.append((animated: flag, completion: completion))
    }

    func mockIsPresenting() {
        isPresenting = true
    }
}

private class CallWindowSpy: CallWindowProtocol {

    var isHidden: Bool = false

    private(set) var makeKeyAndVisibleInvocations: [Void] = []
    private(set) var setRootViewControllerInvocations = [(controller: UIViewController?, animated: Bool, completion: ((Bool) -> Void)?)]()

    func makeKeyAndVisible() {
        makeKeyAndVisibleInvocations.append(())
    }

    func set(rootViewController controller: UIViewController?, animated: Bool, completion: ((Bool) -> Void)?) {
        setRootViewControllerInvocations.append((controller: controller, animated: animated, completion: completion))
    }
}
