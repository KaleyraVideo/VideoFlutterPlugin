// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension AccessTokenRequest: Encodable {

    private enum CodingKeys: String, CodingKey {
        case requestID
        case userID
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestID, forKey: .requestID)
        try container.encode(userID, forKey: .userID)
    }
}

extension AccessTokenRequest {

    func JSONEncoded() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
