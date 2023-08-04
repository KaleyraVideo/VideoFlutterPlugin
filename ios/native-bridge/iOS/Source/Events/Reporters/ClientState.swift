// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
enum ClientState: String {
    case stopped = "stopped"
    case connecting = "connecting"
    case ready = "ready"
    case paused = "paused"
    case reconnecting = "reconnecting"
    case failed = "failed"
}

@available(iOS 12.0, *)
extension ClientState {

    init?(clientState: CallClientState) {
        switch clientState {
            case .stopped:
                self = .stopped
            case .starting:
                self = .connecting
            case .running:
                self = .ready
            case .resuming:
                self = .connecting
            case .paused:
                self = .paused
            case .reconnecting:
                self = .reconnecting
            case .failed:
                self = .failed
            default:
                return nil
        }
    }

    init?(clientState: ChatClientState) {
        switch clientState {
            case .stopped:
                self = .stopped
            case .starting:
                self = .connecting
            case .running:
                self = .ready
            case .resuming:
                self = .connecting
            case .paused:
                self = .paused
            case .reconnecting:
                self = .reconnecting
            case .failed:
                self = .failed
            default:
                return nil
        }
    }
}
