// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension CallOptions: Decodable {

    private enum CodingKeys: String, CodingKey {
        case recordingType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recordingType = try container.decodeIfPresent(RecordingType.self, forKey: .recordingType)
    }
}
