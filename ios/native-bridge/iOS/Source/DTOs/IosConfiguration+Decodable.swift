// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension IosConfiguration: Decodable {

    private enum CodingKeys: String, CodingKey {
        case callkit
        case voipHandlingStrategy
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.callkit = try container.decodeIfPresent(CallKitConfiguration.self, forKey: .callkit) ?? .init(appIconName: nil, enabled: true, ringtoneSoundName: nil)
        self.voipHandlingStrategy = try container.decodeIfPresent(VoipHandlingStrategy.self, forKey: .voipHandlingStrategy)
    }
}
