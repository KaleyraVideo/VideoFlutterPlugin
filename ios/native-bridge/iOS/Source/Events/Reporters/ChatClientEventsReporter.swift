// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Combine
import KaleyraVideoSDK

class ChatClientEventsReporter: NSObject {

    private let conversation: Conversation
    private let emitter: EventEmitter
    private var stateCancellable: AnyCancellable?

    var isRunning: Bool {
        stateCancellable != nil
    }

    init(conversation: Conversation, emitter: EventEmitter) {
        self.conversation = conversation
        self.emitter = emitter
        super.init()
    }

    func start<S: Scheduler>(scheduler: S = DispatchQueue.main) {
        guard !isRunning else { return }

        stateCancellable = conversation.statePublisher.dropFirst().receive(on: scheduler).sink { [weak self] _ in
            self?.notifyNewClientState()
        }
    }

    func stop() {
        guard isRunning else { return }

        stateCancellable = nil
    }

    // MARK: - Events Notification

    private func notifyNewClientState() {
        notifyErrorIfNeeded()

        guard let clientState = ClientState(state: conversation.state) else { return }
        emitter.sendEvent(Events.chatModuleStatusChanged, args: clientState.rawValue)
    }

    private func notifyErrorIfNeeded() {
        guard case KaleyraVideoSDK.ClientState.disconnected(error: let error) = conversation.state, let error else { return }
        emitter.sendEvent(Events.chatError, args: error.localizedDescription)
    }
}
