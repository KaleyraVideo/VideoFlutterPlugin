// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class CallClientEventsReporter: NSObject, CallClientObserver {

    private let client: CallClient
    private let emitter: EventEmitter
    private(set) var isRunning = false

    init(client: CallClient, emitter: EventEmitter) {
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

    // MARK: - Call client observer

    func callClientDidChangeState(_ client: CallClient, oldState: CallClientState, newState: CallClientState) {
        guard let clientState = ClientState(clientState: newState) else { return }

        emitter.sendEvent(Events.callModuleStatusChanged, args: clientState.rawValue)
    }

    func callClient(_ client: CallClient, didFailWithError error: Error) {
        emitter.sendEvent(Events.callError, args: error.localizedDescription)
        emitter.sendEvent(Events.callModuleStatusChanged, args: ClientState.failed.rawValue)
    }
}
