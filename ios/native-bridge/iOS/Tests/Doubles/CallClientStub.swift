// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class CallClientStub: NSObject, CallClient {

    var state: CallClientState = .stopped {
        willSet {
            guard state != newValue else { return }

            observers.forEach({ $0.callClientWillChangeState(self, oldState: state, newState: newValue) })
        }
        didSet {
            guard state != oldValue else { return }

            observers.forEach({ $0.callClientDidChangeState(self, oldState: oldValue, newState: state) })
        }
    }

    private(set) lazy var observers = [Weak<CallClientObserver>]()
    private(set) lazy var incomingCallObserver = [Weak<IncomingCallObserver>]()

    func add(observer: CallClientObserver) {
        add(observer: observer, queue: nil)
    }

    func add(observer: CallClientObserver, queue: DispatchQueue?) {
        observers.append(Weak(observer))
    }

    func remove(observer: CallClientObserver) {
        observers.removeAll(where: { $0.object === observer })
    }

    func addIncomingCall(observer: IncomingCallObserver) {
        addIncomingCall(observer: observer, queue: nil)
    }

    func addIncomingCall(observer: IncomingCallObserver, queue: DispatchQueue?) {
        incomingCallObserver.append(Weak(observer))
    }

    func removeIncomingCall(observer: IncomingCallObserver) {
        incomingCallObserver.removeAll(where: { $0.object === observer })
    }

    func hasIncomingCallObserver(_ observer: IncomingCallObserver) -> Bool {
        incomingCallObserver.contains(where: { $0.object === observer })
    }

    func simulateFailure(error: Error) {
        observers.forEach({ $0.callClient(self, didFailWithError: error) })
    }

    func clientObservers() -> Int {
        observers.count
    }
}

@available(iOS 12.0, *)
extension Weak where Object: CallClientObserver {

    func callClientWillChangeState(_ client: Bandyer.CallClient, oldState: Bandyer.CallClientState, newState: Bandyer.CallClientState) {
        object?.callClientWillChangeState?(client, oldState: oldState, newState: newState)
    }

    func callClientDidChangeState(_ client: Bandyer.CallClient, oldState: Bandyer.CallClientState, newState: Bandyer.CallClientState) {
        object?.callClientDidChangeState(client, oldState: oldState, newState: newState)
    }

    func callClient(_ client: Bandyer.CallClient, didFailWithError error: Error) {
        object?.callClient?(client, didFailWithError: error)
    }
}
