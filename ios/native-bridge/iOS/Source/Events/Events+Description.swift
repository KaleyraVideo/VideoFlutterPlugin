// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension Events: CustomStringConvertible {

    var description: String {
        switch self {
            case .accessTokenRequest:
                return "accessTokenRequest"
            case .callError:
                return "callError"
            case .callModuleStatusChanged:
                return "callModuleStatusChanged"
            case .chatError:
                return "chatError"
            case .chatModuleStatusChanged:
                return "chatModuleStatusChanged"
            case .iOSVoipPushTokenInvalidated:
                return "iOSVoipPushTokenInvalidated"
            case .iOSVoipPushTokenUpdated:
                return "iOSVoipPushTokenUpdated"
            case .setupError:
                return "setupError"
        }
    }
}
