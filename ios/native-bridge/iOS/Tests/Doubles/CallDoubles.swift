// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Combine
import KaleyraVideoSDK

class CallDummy: NSObject, KaleyraVideoSDK.Call {

    let id: UUID = .init()

    let serverId: String? = nil

    let options: KaleyraVideoSDK.CallOptions? = nil

    var optionsPublisher: AnyPublisher<KaleyraVideoSDK.CallOptions?, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }

    let participants: any KaleyraVideoSDK.CallParticipants = CallParticipantsDummy()

    var participantsPublisher: AnyPublisher<any KaleyraVideoSDK.CallParticipants, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }

    var isGroupCall: Bool = false

    var isOutgoing: Bool = false

    var hasUpgradedToVideo: Bool = false

    var upgradePublisher: AnyPublisher<Bool, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }

    var state: KaleyraVideoSDK.CallState = .disconnected

    var statePublisher: AnyPublisher<KaleyraVideoSDK.CallState, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }

    var recording: KaleyraVideoSDK.CallRecording { fatalError() }

    func upgradeToVideo(completion: @escaping (Result<Void, any Error>) -> Void) {}

    func end(completion: @escaping (Result<Void, any Error>) -> Void) {}
}

private class CallParticipantsDummy: NSObject, KaleyraVideoSDK.CallParticipants {

    var all: [any KaleyraVideoSDK.CallParticipant] = []

    var caller: any KaleyraVideoSDK.CallParticipant = CallParticipantDummy()

    var callees: [any KaleyraVideoSDK.CallParticipant] = []
}

private class CallParticipantDummy: NSObject, KaleyraVideoSDK.CallParticipant {

    var userId: String = ""
}
