// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
struct UserInterfacePresenterConfiguration: Equatable {

    enum ChatAudioButtonConfiguration: Equatable {

        case disabled
        case enabled(AudioCallOptions)
    }

    enum ChatVideoButtonConfiguration: Equatable {

        case disabled
        case enabled(CallOptions)
    }

    let showsFeedbackWhenCallEnds: Bool
    let chatAudioButtonConf: ChatAudioButtonConfiguration
    let chatVideoButtonConf: ChatVideoButtonConfiguration

    var chatHasAudioButton: Bool {
        chatAudioButtonConf != .disabled
    }

    var chatHasVideoButton: Bool {
        chatVideoButtonConf != .disabled
    }
}

@available(iOS 12.0, *)
class KaleyraVideoSDKUserInterfacePresenter: NSObject, UserInterfacePresenter {

    // MARK: - Properties

    private let sdk: BandyerSDKProtocol
    private let viewControllerPresenter: ViewControllerPresenter
    private let callWindow: CallWindowProtocol
    private let formatter: Formatter

    private var configuration = UserInterfacePresenterConfiguration(showsFeedbackWhenCallEnds: false,
                                                                    chatAudioButtonConf: .disabled,
                                                                    chatVideoButtonConf: .disabled)

    // MARK: - Init

    init(sdk: BandyerSDKProtocol,
         viewControllerPresenter: ViewControllerPresenter,
         callWindow: CallWindowProtocol,
         formatter: Formatter) {
        self.sdk = sdk
        self.viewControllerPresenter = viewControllerPresenter
        self.callWindow = callWindow
        self.formatter = formatter

        super.init()

        setupCallWindow()
    }

    convenience init(rootViewController: UIViewController?, formatter: Formatter) {
        self.init(sdk: BandyerSDK.instance,
                  viewControllerPresenter: KaleyraVideoSDKUserInterfacePresenter.makeViewControllerPresenter(rootViewController),
                  callWindow: KaleyraVideoSDKUserInterfacePresenter.makeCallWindow(),
                  formatter: formatter)
    }

    private static func makeCallWindow() -> CallWindow {
        guard let instance = CallWindow.instance else {
            return CallWindow()
        }
        return instance
    }

    private static func makeViewControllerPresenter(_ rootViewController: UIViewController?) -> ViewControllerPresenter {
        if let rootViewController = rootViewController {
            return PresentingViewControllerViewControllerPresenter(presentingViewController: rootViewController)
        } else {
            return WindowViewControllerPresenter()
        }
    }

    // MARK: - Setup

    private func setupCallWindow() {
        callWindow.callDelegate = self
    }

    private func setupSDK() {
        sdk.callClient.addIncomingCall(observer: self, queue: .main)
    }

    private func setupNotificationCoordinator() {
        sdk.notificationsCoordinator?.chatListener = self
        sdk.notificationsCoordinator?.fileShareListener = self
        sdk.notificationsCoordinator?.formatter = formatter
        sdk.notificationsCoordinator?.start()
    }

    // MARK: - Configuration

    func configure(with configuration: UserInterfacePresenterConfiguration) {
        self.configuration = configuration

        setupSDK()
        setupNotificationCoordinator()
    }

    // MARK: - Presenting Call UI

    func presentCall(_ options: CreateCallOptions) {
        let intent = options.makeStartOutgoingCallIntent()
        handleCallIntent(intent)
    }

    func presentCall(_ url: URL) {
        let intent = JoinURLIntent(url: url)
        handleCallIntent(intent)
    }

    private func makeCallViewControllerConfiguration() -> CallViewControllerConfiguration {
        let builder = CallViewControllerConfigurationBuilder().withFormatter(formatter)

        if configuration.showsFeedbackWhenCallEnds {
            _ = builder.withFeedbackEnabled()
        }

        return builder.build()
    }

    // MARK: - Presenting Chat UI

    func presentChat(with userID: String) {
        let intent = OpenChatIntent.openChat(with: userID)
        handleChatIntent(intent)
    }

    private func makeChannelViewController(intent: OpenChatIntent) -> ChannelViewController {
        let config = ChannelViewControllerConfiguration(audioButton: configuration.chatHasAudioButton,
                                                        videoButton: configuration.chatHasVideoButton,
                                                        formatter: formatter)
        let controller = ChannelViewController()
        controller.delegate = self
        controller.configuration = config
        controller.intent = intent
        return controller
    }

    // MARK: - Intents

    private func handleChatIntent(_ intent: OpenChatIntent) {
        let channelViewController = makeChannelViewController(intent: intent)

        let continueWith: (() -> Void) = { [weak self] in
            self?.viewControllerPresenter.present(channelViewController, animated: true, completion: nil)
        }

        if viewControllerPresenter.isPresenting {
            viewControllerPresenter.dismissAll(animated: true, completion: continueWith)
        } else {
            continueWith()
        }
    }

    private func handleCallIntent(_ intent: Intent) {
        callWindow.setConfiguration(makeCallViewControllerConfiguration())
        callWindow.presentCallViewController(for: intent) { [weak self] error in
            guard let self = self else { return }
            guard error != nil else { return }

            self.viewControllerPresenter.displayAlert(title: "Warning", message: "Another call ongoing", dismissButtonText: "OK")
        }
    }
}

// MARK: - CallWindowDelegate

@available(iOS 12.0, *)
extension KaleyraVideoSDKUserInterfacePresenter: CallWindowDelegate {

    func callWindowDidFinish(_ window: Bandyer.CallWindow) {
        callWindow.isHidden = true
    }

    func callWindow(_ window: CallWindow, openChatWith intent: OpenChatIntent) {
        handleChatIntent(intent)
    }
}

// MARK: - IncomingCallObserver

@available(iOS 12.0, *)
extension KaleyraVideoSDKUserInterfacePresenter: IncomingCallObserver {

    func callClient(_ client: Bandyer.CallClient, didReceiveIncomingCall call: Bandyer.Call) {
        handleCallIntent(HandleIncomingCallIntent(call: call))
    }
}

// MARK: - InAppChatNotificationTouchListener

@available(iOS 12.0, *)
extension KaleyraVideoSDKUserInterfacePresenter: InAppChatNotificationTouchListener {

    func onTouch(_ notification: Bandyer.ChatNotification) {
        guard let intent = OpenChatIntent.openChat(from: notification) else { return }
        handleChatIntent(intent)
    }
}

// MARK: - InAppFileShareNotificationTouchListener

@available(iOS 12.0, *)
extension KaleyraVideoSDKUserInterfacePresenter: InAppFileShareNotificationTouchListener {

    func onTouch(_ notification: Bandyer.FileShareNotification) {
        callWindow.presentCallViewController(for: OpenDownloadsIntent()) { _ in }
    }
}

// MARK: - ChannelViewControllerDelegate

@available(iOS 12.0, *)
extension KaleyraVideoSDKUserInterfacePresenter: ChannelViewControllerDelegate {

    func channelViewControllerDidFinish(_ controller: Bandyer.ChannelViewController) {
        viewControllerPresenter.dismiss(controller, animated: true, completion: nil)
    }

    func channelViewController(_ controller: Bandyer.ChannelViewController, didTapAudioCallWith users: [String]) {
        guard case let .enabled(audioOptions) = configuration.chatAudioButtonConf else { return }

        let options = audioOptions.callOptions
        let intent = StartOutgoingCallIntent(callees: users, options: options)
        handleCallIntent(intent)
    }

    func channelViewController(_ controller: Bandyer.ChannelViewController, didTapVideoCallWith users: [String]) {
        guard case let .enabled(videoOptions) = configuration.chatVideoButtonConf else { return }

        let options = videoOptions.callOptions
        let intent = StartOutgoingCallIntent(callees: users, options: options)
        handleCallIntent(intent)
    }
}
