// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
extension Region {

    var bandyerRegion: Bandyer.Region? {
        switch name.lowercased() {
            case "europe", "eu":
                return .europe
            case "india", "in":
                return .india
            case "us", "usa":
                return .us
            default:
                return nil
        }
    }
}
