// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension CallKitConfiguration: Decodable {

    private enum CodingKeys: String, CodingKey {
        case enabled
        case appIconName
        case ringtoneSoundName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
        self.appIconName = try container.decodeIfPresent(String.self, forKey: .appIconName)
        self.ringtoneSoundName = try container.decodeIfPresent(String.self, forKey: .ringtoneSoundName)
    }
}
