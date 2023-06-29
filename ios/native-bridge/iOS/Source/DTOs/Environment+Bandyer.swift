// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
extension Environment {

    var bandyerEnvironment: Bandyer.Environment? {
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
