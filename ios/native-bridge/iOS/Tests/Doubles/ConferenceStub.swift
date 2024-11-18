// Copyright © 2018-2024 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Combine
import PushKit
import KaleyraVideoSDK

class ConferenceStub: Conference {

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

    var settings: KaleyraVideoSDK.ConferenceSettings {
        get {
            KaleyraVideo.instance.conference!.settings
        } set {

        }
    }

    var call: KaleyraVideoSDK.Call? = nil {
        didSet {
            callSubject.send(call)
        }
    }

    private lazy var callSubject: CurrentValueSubject<KaleyraVideoSDK.Call?, Never> = .init(nil)

    var callPublisher: AnyPublisher<(any KaleyraVideoSDK.Call)?, Never> {
        callSubject.eraseToAnyPublisher()
    }
    
    private lazy var voipCredentialsSubject: CurrentValueSubject<KaleyraVideoSDK.VoIPCredentials?, Never> = .init(nil)

    var voipCredentialsPublisher: AnyPublisher<KaleyraVideoSDK.VoIPCredentials?, Never> {
        voipCredentialsSubject.eraseToAnyPublisher()
    }

    private(set) lazy var callInvocations = [(callees: [String], options: KaleyraVideoSDK.CallOptions, chatId: String?, completion: (Result<Void, any Error>) -> Void)]()
    private(set) lazy var joinInvocations = [(url: URL, completion: (Result<Void, any Error>) -> Void)]()
    private(set) lazy var handleNotificationInvocations = [PKPushPayload]()

    func call(callees: [String], options: KaleyraVideoSDK.CallOptions, completion: @escaping (Result<Void, any Error>) -> Void) {
        callInvocations.append((callees: callees, options: options, chatId: nil, completion: completion))
    }

    func call(callees: [String], options: KaleyraVideoSDK.CallOptions, chatId: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        callInvocations.append((callees: callees, options: options, chatId: chatId, completion: completion))
    }

    func join(url: URL, completion: @escaping (Result<Void, any Error>) -> Void) {
        joinInvocations.append((url: url, completion: completion))
    }

    func handleNotification(_ payload: PKPushPayload) {
        handleNotificationInvocations.append(payload)
    }

    func simulateCallSucceed() {
        callInvocations.forEach({
            $0.completion(.success(()))
        })
        call = CallDummy()
    }

    func simulateJoinSucceed() {
        joinInvocations.forEach({
            $0.completion(.success(()))
        })
        call = CallDummy()
    }

    func simulateVoIPCredentials(_ credentials: VoIPCredentials) {
        voipCredentialsSubject.send(credentials)
    }

    func simulateFailure(error: Error) {
        state = .disconnected(error: error)
    }
}
