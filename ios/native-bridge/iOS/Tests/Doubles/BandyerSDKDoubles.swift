// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class BandyerSDKProtocolSpy: BandyerSDKProtocol {

    var config: Bandyer.Config? {
        configureInvocations.first
    }

    let notificationsCoordinatorSpy = InAppNotificationsCoordinatorSpy()

    var userDetailsProvider: UserDetailsProvider?
    let callClientStub = CallClientStub()
    var callClient: CallClient! {
        callClientStub
    }
    let chatClient: ChatClient! = ChatClientStub()
    var notificationsCoordinator: InAppNotificationsCoordinator? {
        notificationsCoordinatorSpy
    }
    var callRegistry: Bandyer.CallRegistry!

    private(set) var configureInvocations = [Config]()
    private(set) var connectInvocations = [Bandyer.Session]()
    private(set) var verifiedUserInvocations = [(verified: Bool, call: Bandyer.Call, completion: ((Error?) -> Void)?)]()
    private(set) var disconnectInvocations: [()] = []

    func configure(_ config: Config) {
        configureInvocations.append(config)
    }

    func connect(_ session: Bandyer.Session) {
        connectInvocations.append(session)
    }

    func verifiedUser(_ verified: Bool, for call: Bandyer.Call, completion: ((Error?) -> Void)?) {
        verifiedUserInvocations.append((verified: verified, call: call, completion: completion))
    }

    func disconnect() {
        disconnectInvocations.append(())
    }
}

@available(iOS 12.0, *)
class InAppNotificationsCoordinatorSpy: InAppNotificationsCoordinator {

    var chatListener: Bandyer.InAppChatNotificationTouchListener?
    var fileShareListener: Bandyer.InAppFileShareNotificationTouchListener?
    var formatter: Formatter?
    var theme: Bandyer.Theme?

    private(set) var startInvocations: [()] = []
    private(set) var stopInvocations: [()] = []

    func start() {
        startInvocations.append(())
    }

    func stop() {
        stopInvocations.append(())
    }
}

@available(iOS 12.0, *)
class BandyerSDKProtocolDummy: BandyerSDKProtocol {

    var config: Bandyer.Config?

    var userDetailsProvider: Bandyer.UserDetailsProvider?

    var callClient: Bandyer.CallClient! = CallClientStub()

    var chatClient: Bandyer.ChatClient! = ChatClientStub()

    var notificationsCoordinator: Bandyer.InAppNotificationsCoordinator?

    var callRegistry: Bandyer.CallRegistry!

    func configure(_ config: Bandyer.Config) {}

    func connect(_ session: Bandyer.Session) {}

    func verifiedUser(_ verified: Bool, for call: Bandyer.Call, completion: ((Error?) -> Void)?) {}

    func disconnect() {}
}
