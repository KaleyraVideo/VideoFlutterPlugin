// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension ChatToolConfiguration: Decodable {

    private enum CodingKeys: String, CodingKey {
        case audioCallOption
        case videoCallOption
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.audioCallOption = try container.decodeIfPresent(AudioCallOptions.self, forKey: .audioCallOption)
        self.videoCallOption = try container.decodeIfPresent(CallOptions.self, forKey: .videoCallOption)
    }
}
