// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

enum ClientState: String {
    case disconnected = "disconnected"
    case connecting = "connecting"
    case connected = "connected"
    case reconnecting = "reconnecting"
    case failed = "failed"
}

extension ClientState {

    init?(state: KaleyraVideoSDK.ClientState) {
        switch state {
            case .disconnected(error: let error):
                if error != nil {
                    self = .failed
                } else {
                    self = .disconnected
                }
            case .connecting:
                self = .connecting
            case .connected:
                self = .connected
            case .reconnecting:
                self = .reconnecting
        }
    }
}
