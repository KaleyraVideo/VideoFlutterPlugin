// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

extension Environment {

    var kaleyraEnvironment: KaleyraVideoSDK.Environment? {
        switch name.lowercased() {
            case "production":
                return .production
            case "sandbox":
                return .sandbox
            default:
                return nil
        }
    }
}
