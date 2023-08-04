// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension Tools: Decodable {

    private enum CodingKeys: String, CodingKey {
        case chat
        case fileShare
        case whiteboard
        case screenShare
        case feedback
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chat = try container.decodeIfPresent(ChatToolConfiguration.self, forKey: .chat)
        self.fileShare = try container.decodeIfPresent(Bool.self, forKey: .fileShare) ?? false
        self.whiteboard = try container.decodeIfPresent(Bool.self, forKey: .whiteboard) ?? false
        self.screenShare = try container.decodeIfPresent(ScreenShareToolConfiguration.self, forKey: .screenShare) ?? .init(inApp: false, wholeDevice: false)
        self.feedback = try container.decodeIfPresent(Bool.self, forKey: .feedback) ?? false
    }
}
