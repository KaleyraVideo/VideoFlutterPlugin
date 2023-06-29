// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension CreateCallOptions: Decodable {

    private enum CodingKeys: String, CodingKey {
        case callees
        case callType
        case recordingType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.callees = try container.decode([String].self, forKey: .callees)
        self.callType = try container.decode(CallType.self, forKey: .callType)
        self.recordingType = try container.decodeIfPresent(RecordingType.self, forKey: .recordingType) ?? RecordingType.none
    }
}

extension CreateCallOptions: JSONDecodable {}
