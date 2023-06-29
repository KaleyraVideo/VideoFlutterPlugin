// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class KaleyraVideoSDKUserInterfacePresenterTests: UnitTestCase {

    private var sdkSpy: BandyerSDKProtocolSpy!
    private var viewControllerPresenterSpy: ViewControllerPresenterSpy!
    private var callWindowSpy: CallWindowSpy!
    private var formatterDummy: FormatterDummy!
    private var sut: KaleyraVideoSDKUserInterfacePresenter!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        sdkSpy = makeBandyerSDKProtocolSpy()
        viewControllerPresenterSpy = makeViewControllerPresenterSpy()
        callWindowSpy = makeCallWindowSpy()
        formatterDummy = makeFormatterDummy()
        sut = makeSUT(sdk: sdkSpy, viewControllerPresenter: viewControllerPresenterSpy, callWindow: callWindowSpy, formatter: formatterDummy)

        BandyerSDK.instance.configure(try! ConfigBuilder(appID: "app_id", environment: .sandbox, region: .europe).build())
    }

    override func tearDownWithError() throws {
        sut = nil
        sdkSpy = nil
        viewControllerPresenterSpy = nil
        formatterDummy = nil

        try super.tearDownWithError()
    }

    // MARK: - Init

    func testShouldSetSelfAsCallWindowDelegate() {
        let callWindow = makeCallWindowSpy()
        let sut = makeSUT(sdk: makeBandyerSDKProtocolSpy(), viewControllerPresenter: makeViewControllerPresenterSpy(), callWindow: callWindow, formatter: makeFormatterDummy())

        assertThat(callWindow.callDelegate, presentAnd(instanceOfAnd(equalTo(sut))))
    }

    // MARK: - Configure

    func testConfigureShouldSetSelfAsIncomingCallObserver() {
        sut.configure(with: makeUserInterfacePresenterConfiguration())

        assertThat(sdkSpy.callClientStub.hasIncomingCallObserver(sut), isTrue())
    }

    func testConfigureShouldSetupNotificationCoordinator() {
        sut.configure(with: makeUserInterfacePresenterConfiguration())

        assertThat(sdkSpy.notificationsCoordinatorSpy.chatListener, presentAnd(instanceOfAnd(equalTo(sut))))
        assertThat(sdkSpy.notificationsCoordinatorSpy.fileShareListener, presentAnd(instanceOfAnd(equalTo(sut))))
        assertThat(sdkSpy.notificationsCoordinatorSpy.formatter, presentAnd(instanceOfAnd(sameInstance(formatterDummy))))
        assertThat(sdkSpy.notificationsCoordinatorSpy.startInvocations, hasCount(1))
    }

    // MARK: - Present Chat UI

    func testPresentChatShouldPresentAChannelViewControllerOnViewControllerPresenter() {
        sut.presentChat(with: "user_id")

        assert(presenter: viewControllerPresenterSpy, hasPresented: ChannelViewController.self)
    }

    func testPresentChatShouldCreateAndPassToChannelViewControllerAnOpenChatIntent() throws {
        let expectedIntent = makeOpenChatIntent(userID: "user_id")

        sut.presentChat(with: "user_id")
        let channelVC = try unwrap(viewControllerPresenterSpy.presentInvocations.first?.viewController as? ChannelViewController)

        assertThat(channelVC.intent, presentAnd(equalTo(expectedIntent)))
    }

    func testPresentChatShouldConfigureChannelViewController() throws {
        sut.presentChat(with: "user_id")
        let channelVC = try unwrap(viewControllerPresenterSpy.presentInvocations.first?.viewController as? ChannelViewController)

        assertThat(channelVC.delegate, presentAnd(instanceOfAnd(equalTo(sut))))
        assertThat(channelVC.configuration, present())
    }

    func testCallWindowOpenChatWithIntentShouldPresentChatUI() throws {
        let intent = makeOpenChatIntent()

        sut.callWindow(makeCallWindow(), openChatWith: intent)

        assert(presenter: viewControllerPresenterSpy, hasPresented: ChannelViewController.self)
        let channelVC = try unwrap(viewControllerPresenterSpy.presentInvocations.first?.viewController as? ChannelViewController)
        assertThat(channelVC.intent, presentAnd(equalTo(intent)))
    }

    func testChannelViewControllerDidFinishShouldDismissUsingViewControllerPresenter() {
        let controller = makeChannelViewController()

        sut.channelViewControllerDidFinish(controller)

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

        assert(presenter: viewControllerPresenterSpy, hasPresented: ChannelViewController.self)
    }

    // MARK: - Present Call UI

    func testPresentCallShouldSetCallViewControllerConfigurationOnCallWindow() {
        sut.configure(with: makeUserInterfacePresenterConfiguration(showsFeedbackWhenCallEnds: true))
        sut.presentCall(makeCreateCallOptions())

        assertThat(callWindowSpy.setConfigurationInvocations, hasCount(1))
        assertThat(callWindowSpy.setConfigurationInvocations.first??.isFeedbackEnabled, presentAnd(isTrue()))
        assertThat(callWindowSpy.setConfigurationInvocations.first??.formatter, present())
    }

    func testPresentCallShouldCallPresentCallViewControllerOnCallWindow() {
        let options = makeCreateCallOptions(callees: ["user_id", "other_user_id"],
                                            callType: .audioUpgradable,
                                            recordingType: .manual)

        sut.presentCall(options)

        assertThat(callWindowSpy.presentCallViewControllerInvocations, hasCount(1))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.intent, presentAnd(instanceOfAnd(equalTo(options.makeStartOutgoingCallIntent()))))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.completion, present())
    }

    func testPresentCallFromUrlShouldCallPresentCallViewControllerOnCallWindow() throws {
        let url = try URL.fromString("https://www.kaleyra.com")
        let expectedIntent = JoinURLIntent(url: url)

        sut.presentCall(url)

        assertThat(callWindowSpy.presentCallViewControllerInvocations, hasCount(1))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.intent, presentAnd(instanceOfAnd(equalTo(expectedIntent))))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.completion, present())
    }

    func testDetectedIncomingCallShouldCallPresentCallViewControllerOnCallWindow() {
        let call = makeCall()
        let expectedIntent = HandleIncomingCallIntent(call: call)

        sut.callClient(makeCallClient(), didReceiveIncomingCall: call)

        assertThat(callWindowSpy.presentCallViewControllerInvocations, hasCount(1))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.intent, presentAnd(instanceOfAnd(equalTo(expectedIntent))))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.completion, present())
    }

    func testPresentCallViewControllerErrorShouldDisplayAnAlert() throws {
        let options = makeCreateCallOptions()

        sut.presentCall(options)
        let completion = try unwrap(callWindowSpy.presentCallViewControllerInvocations.first?.completion)
        completion(anyNSError())

        assertThat(viewControllerPresenterSpy.displayAlertInvocations, hasCount(1))
        assertThat(viewControllerPresenterSpy.displayAlertInvocations.first?.title, presentAnd(equalTo("Warning")))
        assertThat(viewControllerPresenterSpy.displayAlertInvocations.first?.message, presentAnd(equalTo("Another call ongoing")))
        assertThat(viewControllerPresenterSpy.displayAlertInvocations.first?.dismissButtonText, presentAnd(equalTo("OK")))
    }

    func testCallWindowDidFinishShouldHideCallWindow() {
        callWindowSpy.isHidden = false
        sut.callWindowDidFinish(makeCallWindow())

        assertThat(callWindowSpy.isHidden, isTrue())
    }

    func testChannelViewControllerDidTapAudioCallWithUsersShouldNotPresentCallViewControllerIfDisabledInConfig() {
        let config = makeUserInterfacePresenterConfiguration(chatHasAudioButton: false)

        sut.configure(with: config)
        sut.channelViewController(makeChannelViewController(), didTapAudioCallWith: ["user_id"])

        assertThat(viewControllerPresenterSpy.presentInvocations, hasCount(0))
    }

    func testChannelViewControllerDidTapAudioCallWithUsersShouldPresentCallWiewController() {
        let expectedIntent = StartOutgoingCallIntent(callees: ["user_id"], options: makeAudioCallOptions().callOptions)
        let config = makeUserInterfacePresenterConfiguration(chatHasAudioButton: true)

        sut.configure(with: config)
        sut.channelViewController(makeChannelViewController(), didTapAudioCallWith: ["user_id"])

        assertThat(callWindowSpy.presentCallViewControllerInvocations, hasCount(1))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.intent, presentAnd(instanceOfAnd(equalTo(expectedIntent))))
    }

    func testChannelViewControllerDidTapVideoCallWithWithUsersShouldNotPresentCallViewControllerIfDisabledInConfig() {
        let config = makeUserInterfacePresenterConfiguration(chatHasVideoButton: false)

        sut.configure(with: config)
        sut.channelViewController(makeChannelViewController(), didTapVideoCallWith: ["user_id"])

        assertThat(viewControllerPresenterSpy.presentInvocations, hasCount(0))
    }

    func testChannelViewControllerDidTapVideoCallWithUsersShouldPresentCallWiewController() {
        let expectedIntent = StartOutgoingCallIntent(callees: ["user_id"], options: makeCallOptions().callOptions)
        let config = makeUserInterfacePresenterConfiguration(chatHasVideoButton: true)

        sut.configure(with: config)
        sut.channelViewController(makeChannelViewController(), didTapVideoCallWith: ["user_id"])

        assertThat(callWindowSpy.presentCallViewControllerInvocations, hasCount(1))
        assertThat(callWindowSpy.presentCallViewControllerInvocations.first?.intent, presentAnd(instanceOfAnd(equalTo(expectedIntent))))
    }

    // MARK: - Helpers

    private func makeSUT(sdk: BandyerSDKProtocol, viewControllerPresenter: ViewControllerPresenter, callWindow: CallWindowProtocol, formatter: Formatter) -> KaleyraVideoSDKUserInterfacePresenter {
        .init(sdk: sdk, viewControllerPresenter: viewControllerPresenter, callWindow: callWindow, formatter: formatter)
    }

    private func makeBandyerSDKProtocolSpy() -> BandyerSDKProtocolSpy {
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

    private func makeFormatterDummy() -> FormatterDummy {
        .init()
    }

    private func makeCreateCallOptions(callees: [String] = ["user_id"],
                                       callType: KaleyraVideoHybridNativeBridge.CallType = .audioVideo,
                                       recordingType: KaleyraVideoHybridNativeBridge.RecordingType = .none) -> CreateCallOptions {
        .init(callees: callees, callType: callType, recordingType: recordingType)
    }

    private func makeCall() -> CallDummy {
        .init()
    }

    private func makeCallClient() -> CallClientStub {
        .init()
    }

    private func makeCallWindow() -> CallWindow {
        guard let window = CallWindow.instance else {
            return CallWindow()
        }
        return window
    }

    private func makeOpenChatIntent(userID: String = "user_id") -> OpenChatIntent {
        .openChat(with: userID)
    }

    private func makeChannelViewController() -> ChannelViewController {
        .init()
    }

    // MARK: - Assertions

    private func assert<T: UIViewController>(presenter: ViewControllerPresenterSpy, hasPresented type: T.Type) {
        assertThat(presenter.presentInvocations, hasCount(1))
        assertThat(presenter.presentInvocations.first?.viewController, presentAnd(instanceOf(type)))
        assertThat(presenter.presentInvocations.first?.animated, presentAnd(isTrue()))
    }
}

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
private class CallWindowSpy: CallWindowProtocol {

    var isHidden: Bool = false
    var callDelegate: Bandyer.CallWindowDelegate?

    private(set) var setConfigurationInvocations = [CallViewControllerConfiguration?]()
    private(set) var presentCallViewControllerInvocations = [(intent: Bandyer.Intent, completion: ((Error?) -> Void)?)]()

    func setConfiguration(_ configuration: CallViewControllerConfiguration?) {
        setConfigurationInvocations.append(configuration)
    }

    func presentCallViewController(for intent: Bandyer.Intent, completion: ((Error?) -> Void)?) {
        presentCallViewControllerInvocations.append((intent: intent, completion: completion))
    }
}

private class FormatterDummy: Formatter {}
