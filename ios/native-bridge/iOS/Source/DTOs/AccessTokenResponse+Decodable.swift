// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension AccessTokenResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case success
        case requestID
        case data
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.requestID = try container.decode(String.self, forKey: .requestID)
        self.data = try container.decode(String.self, forKey: .data)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
    }
}

extension AccessTokenResponse: JSONDecodable {}
