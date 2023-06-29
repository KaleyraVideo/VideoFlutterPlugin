// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension UserDetailsFormat: Decodable {

    private enum CodingKeys: String, CodingKey {
        case `default`
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userDetailsFormatDefault = try container.decode(String.self, forKey: .default)
        self.androidNotification = nil
    }
}

extension UserDetailsFormat: JSONDecodable {}
