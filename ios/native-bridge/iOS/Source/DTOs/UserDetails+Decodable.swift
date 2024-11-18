// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension UserDetails: Decodable {

    private enum CodingKeys: String, CodingKey {
        case userID
        case name
        case imageUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }
}

extension UserDetails: JSONDecodable {}
