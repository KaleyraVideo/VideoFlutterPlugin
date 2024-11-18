// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let accessTokenRequest = try AccessTokenRequest(json)
//   let accessTokenResponse = try AccessTokenResponse(json)
//   let recordingType = try? JSONDecoder().decode(RecordingType.self, from: jsonData)
//   let callOptions = try CallOptions(json)
//   let audioCallType = try? JSONDecoder().decode(AudioCallType.self, from: jsonData)
//   let audioCallOptions = try AudioCallOptions(json)
//   let callDisplayMode = try? JSONDecoder().decode(CallDisplayMode.self, from: jsonData)
//   let callKitConfiguration = try CallKitConfiguration(json)
//   let callType = try? JSONDecoder().decode(CallType.self, from: jsonData)
//   let chatToolConfiguration = try ChatToolConfiguration(json)
//   let createCallOptions = try CreateCallOptions(json)
//   let environment = try Environment(json)
//   let voipHandlingStrategy = try? JSONDecoder().decode(VoipHandlingStrategy.self, from: jsonData)
//   let iosConfiguration = try IosConfiguration(json)
//   let screenShareToolConfiguration = try ScreenShareToolConfiguration(json)
//   let tools = try Tools(json)
//   let region = try Region(json)
//   let kaleyraVideoConfiguration = try KaleyraVideoConfiguration(json)
//   let session = try Session(json)
//   let userDetails = try UserDetails(json)

import Foundation

// MARK: - AccessTokenRequest
struct AccessTokenRequest {
    let requestID, userID: String
}

// MARK: - AccessTokenResponse
struct AccessTokenResponse {
    let data: String
    let error: String?
    let requestID: String
    let success: Bool
}

/// This class defines the display modes supported per call.
enum CallDisplayMode {
    case background
    case foreground
    case foregroundPictureInPicture
}

/// Options to be used when creating a call
// MARK: - CreateCallOptions
struct CreateCallOptions {
    /// Array of callees identifiers to call.
    let callees: [String]
    /// Type of call to create
    let callType: CallType
    /// May have three different values, NONE, AUTOMATIC, MANUAL
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: none</b>
    let recordingType: RecordingType?
}

/// This class defines the types of calls supported.
///
/// Type of call to create
enum CallType {
    case audio
    case audioUpgradable
    case audioVideo
}

/// Recording type of the call
///
/// May have three different values, NONE, AUTOMATIC, MANUAL
/// <br/>
/// <br/>
/// <b><font color="blue">default</font>: none</b>
enum RecordingType {
    case automatic
    case manual
    case none
}

/// Generic configuration used for setup
// MARK: - KaleyraVideoConfiguration
struct KaleyraVideoConfiguration {
    /// This key will be provided to you by us.
    let appID: String
    /// This variable defines the environment where you will be sandbox or production.
    let environment: Environment
    /// Define to customize the iOS configuration
    let iosConfig: IosConfiguration?
    /// Set to true to enable log, default value is false
    let logEnabled: Bool?
    /// This variable defines the region where you will be europe, india or us.
    let region: Region
    /// Define the tools to use
    let tools: Tools?
}

/// An environment where your integration will run
///
/// This variable defines the environment where you will be sandbox or production.
// MARK: - Environment
struct Environment {
    /// name of the environment
    let name: String
}

/// Configuration for iOS platform
///
/// Define to customize the iOS configuration
// MARK: - IosConfiguration
struct IosConfiguration {
    /// Specify the callkit configuration to enable the usage and it's behaviour
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: enabled</b>
    let callkit: CallKitConfiguration?
    /// Specify the voip handling strategy.
    /// <br/>
    /// This allows you to disable or leave the plugin behaviour for handling the voip
    /// notifications.
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: VoipHandlingStrategy.AUTOMATIC </b>
    let voipHandlingStrategy: VoipHandlingStrategy?
}

/// Configuration for callkit
///
/// Specify the callkit configuration to enable the usage and it's behaviour
/// <br/>
/// <br/>
/// <b><font color="blue">default</font>: enabled</b>
// MARK: - CallKitConfiguration
struct CallKitConfiguration {
    /// The icon resource name to be used in the callkit UI to represent the app
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: null</b>
    let appIconName: String?
    /// Set to false to disable
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: true</b>
    let enabled: Bool?
    /// The ringtone resource name to be used when callkit is launched
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: system</b>
    let ringtoneSoundName: String?
}

/// This class defines the voip notification strategy per call.
///
/// Specify the voip handling strategy.
/// <br/>
/// This allows you to disable or leave the plugin behaviour for handling the voip
/// notifications.
/// <br/>
/// <br/>
/// <b><font color="blue">default</font>: VoipHandlingStrategy.AUTOMATIC </b>
enum VoipHandlingStrategy {
    case automatic
    case disabled
}

/// A region where your integration will run
///
/// This variable defines the region where you will be europe, india or us.
// MARK: - Region
struct Region {
    /// name of the region
    let name: String
}

/// Video Module Tools
///
/// Define the tools to use
// MARK: - Tools
struct Tools {
    /// Set to enable the chat feature
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: no chat</b>
    let chat: ChatToolConfiguration?
    /// Set to true to enable the feedback request after a call ends.
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: false</b>
    let feedback: Bool?
    /// Set to true to enable the file sharing feature
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: false</b>
    let fileShare: Bool?
    /// Set to enable the screen sharing feature
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: no screen share</b>
    let screenShare: ScreenShareToolConfiguration?
    /// Set to true to enable the whiteboard feature
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: false</b>
    let whiteboard: Bool?
}

/// Chat tool configuration
///
/// Set to enable the chat feature
/// <br/>
/// <br/>
/// <b><font color="blue">default</font>: no chat</b>
// MARK: - ChatToolConfiguration
struct ChatToolConfiguration {
    /// Defining this object will enable an option to start an audio call from chat UI
    let audioCallOption: AudioCallOptions?
    /// Defining this object will enable an option to start an audio&video call from chat UI
    let videoCallOption: CallOptions?
}

/// Audio call options used for chat
///
/// Defining this object will enable an option to start an audio call from chat UI
// MARK: - AudioCallOptions
struct AudioCallOptions {
    /// May have three different values, NONE, AUTOMATIC, MANUAL
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: none</b>
    let recordingType: RecordingType?
    /// Type of audioCall to launch when an option of the chat is tapped.
    let type: AudioCallType
}

/// This class defines the types of audio calls supported.
///
/// Type of audioCall to launch when an option of the chat is tapped.
enum AudioCallType {
    case audio
    case audioUpgradable
}

/// Options available for a call
///
/// Defining this object will enable an option to start an audio&video call from chat UI
// MARK: - CallOptions
struct CallOptions {
    /// May have three different values, NONE, AUTOMATIC, MANUAL
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: none</b>
    let recordingType: RecordingType?
}

/// Screen Share tool configuration
///
/// Set to enable the screen sharing feature
/// <br/>
/// <br/>
/// <b><font color="blue">default</font>: no screen share</b>
// MARK: - ScreenShareToolConfiguration
struct ScreenShareToolConfiguration {
    /// Set to true to enable the in app screen share
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: false</b>
    let inApp: Bool?
    /// Set to true to enable the whole device screen share
    /// <br/>
    /// <br/>
    /// <b><font color="blue">default</font>: false</b>
    let wholeDevice: Bool?
}

/// Session
// MARK: - Session
struct Session {
    /// The user id you want to connect
    let userID: String
}

/// This is used to define the user details in the call/chat UI
// MARK: - UserDetails
struct UserDetails {
    /// Image url to use as placeholder for the user.
    let imageURL: String?
    /// The user's display name.
    let name: String?
    /// User identifier
    let userID: String
}
