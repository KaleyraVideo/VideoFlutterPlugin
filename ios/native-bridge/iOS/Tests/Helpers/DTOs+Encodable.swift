// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
@testable import KaleyraVideoHybridNativeBridge

extension KaleyraVideoConfiguration: Encodable {

    private enum CodingKeys: String, CodingKey {
        case appID
        case environment
        case region
        case logEnabled
        case iosConfig
        case tools
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appID, forKey: .appID)
        try container.encode(environment, forKey: .environment)
        try container.encode(region, forKey: .region)
        try container.encode(logEnabled, forKey: .logEnabled)
        try container.encode(iosConfig, forKey: .iosConfig)
        try container.encode(tools, forKey: .tools)
    }

    func JSONEncoded() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}

extension KaleyraVideoHybridNativeBridge.Environment: Encodable {

    private enum CodingKeys: String, CodingKey {
        case name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

extension KaleyraVideoHybridNativeBridge.Region: Encodable {

    private enum CodingKeys: String, CodingKey {
        case name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

extension IosConfiguration: Encodable {

    private enum CodingKeys: String, CodingKey {
        case callkit
        case voipHandlingStrategy
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(callkit, forKey: .callkit)
        try container.encode(voipHandlingStrategy, forKey: .voipHandlingStrategy)
    }
}

extension KaleyraVideoHybridNativeBridge.CallKitConfiguration: Encodable {

    private enum CodingKeys: String, CodingKey {
        case enabled
        case appIconName
        case ringtoneSoundName
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(appIconName, forKey: .appIconName)
        try container.encode(ringtoneSoundName, forKey: .ringtoneSoundName)
    }
}

extension VoipHandlingStrategy: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .automatic:
                try container.encode("automatic")
            case .disabled:
                try container.encode("disabled")
        }
    }
}

extension Tools: Encodable {

    private enum CodingKeys: String, CodingKey {
        case chat
        case fileShare
        case whiteboard
        case screenShare
        case feedback
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chat, forKey: .chat)
        try container.encode(fileShare, forKey: .fileShare)
        try container.encode(whiteboard, forKey: .whiteboard)
        try container.encode(screenShare, forKey: .screenShare)
        try container.encode(feedback, forKey: .feedback)
    }
}

extension KaleyraVideoHybridNativeBridge.ChatToolConfiguration: Encodable {

    private enum CodingKeys: String, CodingKey {
        case audioCallOption
        case videoCallOption
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(audioCallOption, forKey: .audioCallOption)
        try container.encode(videoCallOption, forKey: .videoCallOption)
    }
}

extension ScreenShareToolConfiguration: Encodable {

    private enum CodingKeys: String, CodingKey {
        case inApp
        case wholeDevice
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inApp, forKey: .inApp)
        try container.encode(wholeDevice, forKey: .wholeDevice)
    }
}

extension AudioCallOptions: Encodable {

    private enum CodingKeys: String, CodingKey {
        case recordingType
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recordingType, forKey: .recordingType)
        try container.encode(type, forKey: .type)
    }
}

extension RecordingType: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .automatic:
                try container.encode("automatic")
            case .manual:
                try container.encode("manual")
            case .none:
                try container.encode("none")
        }
    }
}

extension AudioCallType: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .audio:
                try container.encode("audio")
            case .audioUpgradable:
                try container.encode("audioUpgradable")
        }
    }
}

extension KaleyraVideoHybridNativeBridge.CallOptions: Encodable {

    private enum CodingKeys: String, CodingKey {
        case recordingType
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recordingType, forKey: .recordingType)
    }
}

extension CreateCallOptions: Encodable {

    private enum CodingKeys: String, CodingKey {
        case callees
        case callType
        case recordingType
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(callees, forKey: .callees)
        try container.encode(callType, forKey: .callType)
        try container.encode(recordingType, forKey: .recordingType)
    }

    func JSONEncoded() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}

extension KaleyraVideoHybridNativeBridge.CallType: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .audio:
                try container.encode("audio")
            case .audioUpgradable:
                try container.encode("audioUpgradable")
            case .audioVideo:
                try container.encode("audioVideo")
        }
    }
}

extension UserDetails: Encodable {

    private enum CodingKeys: String, CodingKey {
        case userID
        case name
        case imageUrl
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(name, forKey: .name)
        try container.encode(imageURL, forKey: .imageUrl)
    }

    func JSONEncoded() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
