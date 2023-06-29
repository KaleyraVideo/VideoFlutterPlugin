// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension KaleyraVideoConfiguration: Decodable {

    private enum CodingKeys: String, CodingKey {
        case appID
        case environment
        case region
        case logEnabled
        case iosConfig
        case tools
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appID = try container.decode(String.self, forKey: .appID)
        self.environment = try container.decode(Environment.self, forKey: .environment)
        self.region = try container.decode(Region.self, forKey: .region)
        self.logEnabled = try container.decodeIfPresent(Bool.self, forKey: .logEnabled) ?? false
        self.iosConfig = try container.decodeIfPresent(IosConfiguration.self, forKey: .iosConfig)
        self.tools = try container.decodeIfPresent(Tools.self, forKey: .tools)
    }
}

extension KaleyraVideoConfiguration: JSONDecodable {}
