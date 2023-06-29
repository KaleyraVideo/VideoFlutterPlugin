// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class ChatClientEventsReporter: NSObject, ChatClientObserver {

    private let client: ChatClient
    private let emitter: EventEmitter
    private(set) var isRunning = false

    init(client: ChatClient, emitter: EventEmitter) {
        self.client = client
        self.emitter = emitter
        super.init()
    }

    func start() {
        guard !isRunning else { return }

        isRunning = true
        client.add(observer: self, queue: .main)
    }

    func stop() {
        guard isRunning else { return }

        client.remove(observer: self)
        isRunning = false
    }

    // MARK: - Chat client observer

    func chatClientDidChangeState(_ client: ChatClient, oldState: ChatClientState, newState: ChatClientState) {
        guard let clientState = ClientState(clientState: newState) else { return }

        emitter.sendEvent(Events.chatModuleStatusChanged, args: clientState.rawValue)
    }

    func chatClient(_ client: ChatClient, didFailWithError error: Error) {
        emitter.sendEvent(Events.chatError, args: error.localizedDescription)
        emitter.sendEvent(Events.chatModuleStatusChanged, args: ClientState.failed.rawValue)
    }
}
