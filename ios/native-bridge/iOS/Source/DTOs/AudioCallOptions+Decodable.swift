// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension AudioCallOptions: Decodable {

    private enum CodingKeys: String, CodingKey {
        case recordingType
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recordingType = try container.decodeIfPresent(RecordingType.self, forKey: .recordingType)
        self.type = try container.decode(AudioCallType.self, forKey: .type)
    }
}
