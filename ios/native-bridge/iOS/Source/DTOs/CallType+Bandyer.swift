// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
extension CallType {

    var bandyerType: Bandyer.CallType {
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
