// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

extension CallType {

    var bandyerType: KaleyraVideoSDK.CallOptions.CallType {
        switch self {
            case .audio:
                return .audioOnly
            case .audioUpgradable:
                return .audioUpgradable
            case .audioVideo:
                return .audioVideo
        }
    }
}
