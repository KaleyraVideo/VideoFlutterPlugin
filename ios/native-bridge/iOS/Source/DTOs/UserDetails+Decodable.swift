// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension UserDetails: Decodable {

    private enum CodingKeys: String, CodingKey {
        case userID
        case firstName
        case lastName
        case email
        case nickName
        case profileImageURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.nickName = try container.decodeIfPresent(String.self, forKey: .nickName)
        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
    }
}

extension UserDetails: JSONDecodable {}
