// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class CallDummy: NSObject, Bandyer.Call {

    let uuid: UUID = .init()

    let sid: String? = nil

    let options: Bandyer.CallOptions? = nil

    let endReason: Bandyer.CallEndReason = .none

    let declineReason: Bandyer.CallDeclineReason = .none

    func add(observer: Bandyer.CallObserver) {}

    func add(observer: Bandyer.CallObserver, queue: DispatchQueue?) {}

    func remove(observer: Bandyer.CallObserver) {}

    func add(recordingObserver: Bandyer.CallRecordingObserver) {}

    func add(recordingObserver: Bandyer.CallRecordingObserver, queue: DispatchQueue?) {}

    func remove(recordingObserver: Bandyer.CallRecordingObserver) {}

    let participants: Bandyer.CallParticipants = CallParticipantsDummy()

    let isGroupCall: Bool = false

    let isIncoming: Bool = false

    let isOutgoing: Bool = false

    let callType: Bandyer.CallType = .audioVideo

    let hasVideo: Bool = true

    let isAudioVideo: Bool = true

    let isAudioUpgradable: Bool = false

    let isAudioOnly: Bool = false

    let canUpgradeToVideo: Bool = false

    let didUpgradeToVideo: Bool = false

    let state: Bandyer.CallState = .idle

    let recordingState: Bandyer.CallRecordingState = .stopped

    let connectingDate: Date? = nil

    let connectedDate: Date? = nil

    let endDate: Date? = nil

    let isMuted: Bool = false
}

@available(iOS 12.0, *)
private class CallParticipantsDummy: NSObject, Bandyer.CallParticipants {

    var all: [Bandyer.CallParticipant] = []

    var participantsIds: [String] = []

    func participant(identifiedBy identifier: String) -> Bandyer.CallParticipant? {
        nil
    }

    var caller: Bandyer.CallParticipant = CallParticipantDummy()

    var callerId: String = ""

    var callees: [Bandyer.CallParticipant] = []

    var calleesIds: [String] = []

    func callee(identifiedBy identifier: String) -> Bandyer.CallParticipant? {
        nil
    }

    func add(observer: Bandyer.CallParticipantsObserver) {}

    func add(observer: Bandyer.CallParticipantsObserver, queue: DispatchQueue?) {}

    func remove(observer: Bandyer.CallParticipantsObserver) {}
}

@available(iOS 12.0, *)
private class CallParticipantDummy: NSObject, Bandyer.CallParticipant {

    var userId: String = ""

    var state: Bandyer.CallParticipantState = .unknown

    var didUpgradeToVideo: Bool = false
}
