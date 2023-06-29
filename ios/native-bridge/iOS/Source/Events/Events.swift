// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let events = try? JSONDecoder().decode(Events.self, from: jsonData)

import Foundation

/// This enum defines all the events that may be handled
/// <br/>
/// <br/>
/// You can listen to these events via [[BandyerPlugin.on]]
enum Events {
    case accessTokenRequest
    case callError
    case callModuleStatusChanged
    case chatError
    case chatModuleStatusChanged
    case iOSVoipPushTokenInvalidated
    case iOSVoipPushTokenUpdated
    case setupError
}
