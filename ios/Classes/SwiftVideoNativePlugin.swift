// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Flutter
import UIKit
import Bandyer

@available(iOS 12.0, *)
public class SwiftVideoNativePlugin: NSObject, FlutterPlugin {

    // MARK: - Properties

    private let eventEmitter: FlutterEventEmitter

    private lazy var accessTokenProviderFactory: () -> AccessTokenProvider = {
        FlutterAccessTokenProvider(requester: self.eventEmitter)
    }

    private lazy var plugin: VideoHybridNativeBridge = .init(emitter: self.eventEmitter,
                                                             rootViewController: nil,
                                                             accessTokenProviderFactory: accessTokenProviderFactory)

    // MARK: - Init

    init(dartChannel: FlutterMethodChannel) {
        self.eventEmitter = FlutterEventEmitter(dartChannel: dartChannel)

        super.init()
    }

    // MARK: - Plugin Registration

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "kaleyra_native_channel", binaryMessenger: registrar.messenger())
        let dartChannel = FlutterMethodChannel(name: "kaleyra_dart_channel", binaryMessenger: registrar.messenger())

        let instance = SwiftVideoNativePlugin(dartChannel: dartChannel)

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // MARK: - FlutterPlugin Protocol Conformance

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            var returnResult: Any? = nil

            switch (call.method, call.arguments) {
                case ("configureBridge", let json as String):
                    let config = try KaleyraVideoConfiguration.decodeJSON(json)
                    printPluginDebugDescriptionIfNeeded(config)
                    try plugin.configureSDK(config)
                case ("connect", let userID as String):
                    try plugin.connect(userID: userID)
                case("getCurrentVoIPPushToken", _):
                    returnResult = try plugin.getCurrentVoIPPushToken()
                case ("reset", _):
                    plugin.reset()
                case ("setUserDetailsFormat", let json as String):
                    plugin.setUserDetailsFormat(try UserDetailsFormat.decodeJSON(json))
                case ("startCall", let json as String):
                    try plugin.startCall(try CreateCallOptions.decodeJSON(json))
                case ("startChat", let userID as String):
                    try plugin.startChat(userID)
                case ("startCallUrl", let urlString as String):
                    try plugin.startCallUrl(try URL.fromString(urlString))
                case ("disconnect", _):
                    try plugin.disconnect()
                case ("clearUserCache", _):
                    plugin.clearUserCache()
                case ("handlePushNotificationPayload", let json as String):
                    plugin.handlePushNotificationPayload(json)
                case ("addUsersDetails", let jsonList as [String]):
                    plugin.addUsersDetails(try jsonList.map({ try UserDetails.decodeJSON($0) }))
                case ("removeUsersDetails", _):
                    plugin.removeUsersDetails()
                case ("setDisplayModeForCurrentCall", let mode as String):
                    plugin.setDisplayModeForCurrentCall(mode)
                case ("verifyCurrentCall", let verify as Bool):
                    try plugin.verifyCurrentCall(verify)
                default:
                    throw VideoHybridNativeBridgeError.unsupportedFunctionCallError(method: call.method)
            }

            result(returnResult)

        } catch {
            guard let kaleyraVideoPluginError = error as? VideoHybridNativeBridgeError else {
                result(FlutterError.unknownError(from: error))
                return
            }

            result(kaleyraVideoPluginError.toFlutterError())
        }
    }

    // MARK: - Helpers

    private func printPluginDebugDescriptionIfNeeded(_ config: KaleyraVideoConfiguration) {
        guard config.logEnabled ?? false else { return }

        _KaleyraVideoHybridVersionInfo().printDebugDescription()
    }
}

// MARK: - AccessTokenProvider

private class FlutterAccessTokenProvider: AccessTokenProvider {

    private struct FlutterAccessTokenProviderError: Error { }

    private let requester: ChannelAccessTokenRequester

    init(requester: ChannelAccessTokenRequester) {
        self.requester = requester
    }

    func provideAccessToken(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        requester.requestAccessToken(userId: userId) { token in
            if let token = token {
                completion(.success(token))
            } else {
                completion(.failure(FlutterAccessTokenProviderError()))
            }
        }
    }
}

// MARK: - Errors

private extension VideoHybridNativeBridgeError {

    func toFlutterError() -> FlutterError {
        .init(code: code, message: message, details: nil)
    }
}

private extension FlutterError {

    static func unknownError(from error: Error) -> FlutterError {
        .init(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil)
    }
}
