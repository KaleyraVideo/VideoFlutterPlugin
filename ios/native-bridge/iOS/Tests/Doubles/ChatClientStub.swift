// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class ChatClientStub: NSObject, ChatClient {

    var state: ChatClientState = .stopped {
        willSet {
            guard state != newValue else { return }

            observers.forEach({ $0.chatClientWillChangeState(self, oldState: state, newState: newValue) })
        }
        didSet {
            guard state != oldValue else { return }

            observers.forEach({ $0.chatClientDidChangeState(self, oldState: oldValue, newState: state) })
        }
    }

    private(set) lazy var observers = [Weak<ChatClientObserver>]()

    func add(observer: ChatClientObserver) {
        add(observer: observer, queue: nil)
    }

    func add(observer: ChatClientObserver, queue: DispatchQueue?) {
        observers.append(Weak(observer))
    }

    func remove(observer: ChatClientObserver) {
        observers.removeAll(where: { $0.object === observer })
    }

    func simulateFailure(error: Error) {
        observers.forEach({ $0.chatClient(self, didFailWithError: error) })
    }

    func clientObservers() -> Int {
        observers.count
    }
}

@available(iOS 12.0, *)
extension Weak where Object: ChatClientObserver {

    func chatClientWillChangeState(_ client: Bandyer.ChatClient, oldState: Bandyer.ChatClientState, newState: Bandyer.ChatClientState) {
        object?.chatClientWillChangeState?(client, oldState: oldState, newState: newState)
    }

    func chatClientDidChangeState(_ client: Bandyer.ChatClient, oldState: Bandyer.ChatClientState, newState: Bandyer.ChatClientState) {
        object?.chatClientDidChangeState(client, oldState: oldState, newState: newState)
    }

    func chatClient(_ client: Bandyer.ChatClient, didFailWithError error: Error) {
        object?.chatClient?(client, didFailWithError: error)
    }
}
