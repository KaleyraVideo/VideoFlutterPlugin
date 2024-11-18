// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

extension Region {

    var kaleyraRegion: KaleyraVideoSDK.Region? {
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
