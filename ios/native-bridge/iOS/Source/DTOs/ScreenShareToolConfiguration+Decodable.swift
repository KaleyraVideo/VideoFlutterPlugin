// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension ScreenShareToolConfiguration: Decodable {

    private enum CodingKeys: String, CodingKey {
        case inApp
        case wholeDevice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.inApp = try container.decodeIfPresent(Bool.self, forKey: .inApp) ?? false
        self.wholeDevice = try container.decodeIfPresent(Bool.self, forKey: .wholeDevice) ?? false
    }
}
