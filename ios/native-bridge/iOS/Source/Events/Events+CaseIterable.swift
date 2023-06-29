// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension Events: CaseIterable {

    static var allCases: [Events] {
        [.accessTokenRequest,
            .callError,
            .callModuleStatusChanged,
            .chatError,
            .chatModuleStatusChanged,
            .iOSVoipPushTokenInvalidated,
            .iOSVoipPushTokenUpdated,
            .setupError]
    }
}
