// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

protocol ChannelAccessTokenRequester {
    func requestAccessToken(userId: String, completion: @escaping (String?) -> Void)
}

class FlutterEventEmitter: EventEmitter, ChannelAccessTokenRequester {

    // MARK: - Properties

    private let dartChannel: FlutterMethodChannel

    // MARK: Init

    init(dartChannel: FlutterMethodChannel) {
        self.dartChannel = dartChannel
    }

    // MARK: Event Emission

    func sendEvent(_ event: Events, args: Any?) {
        sendEvent(event.description, args: args) { (_: Void?) in }
    }

    private func sendEvent<T>(_ eventName: String, args: Any?, completion: @escaping (T?) -> Void) {
        dartChannel.invokeMethod(eventName, arguments: args) { result in
            completion(result as? T)
        }
    }

    // MARK: - Request Access Token

    func requestAccessToken(userId: String, completion: @escaping (String?) -> Void) {
        sendEvent(Events.accessTokenRequest.description, args: userId, completion: completion)
    }
}
