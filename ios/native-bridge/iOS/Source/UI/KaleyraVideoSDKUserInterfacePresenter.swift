// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Combine
import KaleyraVideoSDK

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

class KaleyraVideoSDKUserInterfacePresenter: NSObject, UserInterfacePresenter {

    // MARK: - Properties

    private let sdk: KaleyraVideoSDKProtocol
    private let viewControllerPresenter: ViewControllerPresenter
    private let callWindow: CallWindowProtocol

    private var configuration = UserInterfacePresenterConfiguration(showsFeedbackWhenCallEnds: false,
                                                                    chatAudioButtonConf: .disabled,
                                                                    chatVideoButtonConf: .disabled)

    private lazy var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(sdk: KaleyraVideoSDKProtocol,
         viewControllerPresenter: ViewControllerPresenter,
         callWindow: CallWindowProtocol) {
        self.sdk = sdk
        self.viewControllerPresenter = viewControllerPresenter
        self.callWindow = callWindow

        super.init()
    }

    convenience init(rootViewController: UIViewController?) {
        self.init(sdk: KaleyraVideo.instance,
                  viewControllerPresenter: KaleyraVideoSDKUserInterfacePresenter.makeViewControllerPresenter(rootViewController),
                  callWindow: KaleyraVideoSDKUserInterfacePresenter.makeCallWindow())
    }

    private static func makeCallWindow() -> CallWindow {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        return .init(windowScene: windowScene)
    }

    private static func makeViewControllerPresenter(_ rootViewController: UIViewController?) -> ViewControllerPresenter {
        if let rootViewController = rootViewController {
            return PresentingViewControllerViewControllerPresenter(presentingViewController: rootViewController)
        } else {
            return WindowViewControllerPresenter()
        }
    }

    // MARK: - Setup

    private func setupSDK() {
        sdk.conference?.callPublisher.compactMap({ $0 }).receive(on: RunLoop.main).sink { [weak self] call in
            self?.present(call: call)
        }.store(in: &subscriptions)
    }

    private func setupNotificationCoordinator() {
        sdk.conversation?.notifications.delegate = self
        sdk.conversation?.notifications.start()
    }

    // MARK: - Configuration

    func configure(with configuration: UserInterfacePresenterConfiguration) {
        self.configuration = configuration

        setupSDK()
        setupNotificationCoordinator()
    }

    // MARK: - Presenting Call UI

    func presentCall(_ options: CreateCallOptions) {
        startCall(callees: options.callees, options: options.makeCallOptions())
    }

    func presentCall(_ url: URL) {
        sdk.conference?.join(url: url) { result in
            do {
                try result.get()
            } catch {
                debugPrint("An error occurred while starting join call \(error)")
            }
        }
    }

    private func startCall(callees: [String], options: KaleyraVideoSDK.CallOptions) {
        sdk.conference?.call(callees: callees,
                             options: options) { result in
            do {
                try result.get()
            } catch {
                debugPrint("An error occurred while starting call \(error)")
            }
        }
    }

    private func present(call: Call) {
        let controller = CallViewController(call: call, configuration: makeCallViewControllerConfiguration())
        controller.delegate = self
        callWindow.makeKeyAndVisible()
        callWindow.set(rootViewController: controller, animated: true, completion: nil)
    }

    private func makeCallViewControllerConfiguration() -> CallViewController.Configuration {
        .init(feedback: configuration.showsFeedbackWhenCallEnds ? .init() : nil)
    }

    // MARK: - Presenting Chat UI

    func presentChat(with userID: String) {
        let intent = ChatViewController.Intent.participant(id: userID)
        handleChatIntent(intent)
    }

    private func makeChannelViewController(intent: ChatViewController.Intent) -> ChatViewController {
        let controller = ChatViewController(intent: intent,
                                            configuration: .init(audioButton: configuration.chatHasAudioButton,
                                                                 videoButton: configuration.chatHasVideoButton))
        controller.delegate = self
        return controller
    }

    // MARK: - Intents

    private func handleChatIntent(_ intent: ChatViewController.Intent) {
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
}

// MARK: - CallViewControllerDelegate

extension KaleyraVideoSDKUserInterfacePresenter: CallViewControllerDelegate {

    func callViewControllerDidFinish(_ controller: KaleyraVideoSDK.CallViewController) {
        callWindow.isHidden = true
    }
}

// MARK: - InAppChatNotificationTouchListener

extension KaleyraVideoSDKUserInterfacePresenter: InAppNotificationsDelegate {

    func onTouch(_ notification: ChatNotification) {
        let intent = ChatViewController.Intent.chat(id: notification.chatId)
        handleChatIntent(intent)
    }
}

// MARK: - ChannelViewControllerDelegate

extension KaleyraVideoSDKUserInterfacePresenter: ChatViewControllerDelegate {

    func chatViewControllerDidFinish(_ controller: KaleyraVideoSDK.ChatViewController) {
        viewControllerPresenter.dismiss(controller, animated: true, completion: nil)
    }

    func chatViewControllerDidTapAudioCallButton(_ controller: KaleyraVideoSDK.ChatViewController) {
        guard case let .enabled(audioOptions) = configuration.chatAudioButtonConf else { return }

        startCall(callees: controller.participants, options: .init(type: audioOptions.type.callType,
                                                                   recording: audioOptions.recordingType?.callRecordingType))
    }

    func chatViewControllerDidTapVideoCallButton(_ controller: KaleyraVideoSDK.ChatViewController) {
        guard case let .enabled(videoOptions) = configuration.chatVideoButtonConf else { return }

        startCall(callees: controller.participants, options: .init(type: .audioVideo,
                                                                   recording: videoOptions.recordingType?.callRecordingType))
    }
}
