// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
extension KaleyraVideoHybridNativeBridge.Environment: Encodable {

    private enum CodingKeys: String, CodingKey {
        case name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

@available(iOS 12.0, *)
extension KaleyraVideoHybridNativeBridge.Region: Encodable {

    private enum CodingKeys: String, CodingKey {
        case name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
extension KaleyraVideoHybridNativeBridge.CallOptions: Encodable {

    private enum CodingKeys: String, CodingKey {
        case recordingType
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recordingType, forKey: .recordingType)
    }
}

@available(iOS 12.0, *)
extension UserDetailsFormat: Encodable {

    private enum CodingKeys: String, CodingKey {
        case `default`
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userDetailsFormatDefault, forKey: .default)
    }

    func JSONEncoded() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
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

@available(iOS 12.0, *)
extension UserDetails: Encodable {

    private enum CodingKeys: String, CodingKey {
        case userID
        case firstName
        case lastName
        case email
        case nickName
        case profileImageURL
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(nickName, forKey: .nickName)
        try container.encode(profileImageURL, forKey: .profileImageURL)
    }

    func JSONEncoded() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
