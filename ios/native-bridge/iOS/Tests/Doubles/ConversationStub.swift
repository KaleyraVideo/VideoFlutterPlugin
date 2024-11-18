// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Combine
import KaleyraVideoSDK

class ConversationStub: NSObject, Conversation {

    var state: KaleyraVideoSDK.ClientState = .disconnected(error: nil) {
        didSet {
            guard state != oldValue else { return }

            stateSubject.send(state)
        }
    }

    private lazy var stateSubject: CurrentValueSubject<KaleyraVideoSDK.ClientState, Never> = .init(.disconnected(error: nil))

    var statePublisher: AnyPublisher<KaleyraVideoSDK.ClientState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    let notificationsSpy = InAppNotificationsSpy()

    var notifications: any KaleyraVideoSDK.InAppNotifications {
        notificationsSpy
    }

    func simulateFailure(error: Error) {
        state = .disconnected(error: error)
    }
}

class InAppNotificationsSpy: InAppNotifications {

    var delegate: (any KaleyraVideoSDK.InAppNotificationsDelegate)?

    private(set) var startInvocations: [Void] = []
    private(set) var stopInvocations: [Void] = []

    func start() {
        startInvocations.append(())
    }
    
    func stop() {
        stopInvocations.append(())
    }
}
