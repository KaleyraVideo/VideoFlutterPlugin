// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
struct VideoHybridNativeBridgeError: Error, Equatable {

    private enum ErrorCodes: String {

        case unsupportedFunction = "UNSUPPORTED_FUNCTION_CALL"
        case invalidUrl = "INVALID_URL_ERROR"
        case sdkNotConfiguredError = "SDK_NOT_CONFIGURED_ERROR"
    }

    let code: String
    let message: String

    static func unsupportedFunctionCallError(method: String) -> VideoHybridNativeBridgeError {
        .init(code: ErrorCodes.unsupportedFunction.rawValue,
              message: "Calling \(method) function is not supported")
    }

    static func unableToInitializeURLError(urlString: String) -> VideoHybridNativeBridgeError {
        .init(code: ErrorCodes.invalidUrl.rawValue,
              message: "Unable to convert the provided string \"\(urlString)\" to URL object")
    }

    static func sdkNotConfiguredError() -> VideoHybridNativeBridgeError {
        .init(code: ErrorCodes.sdkNotConfiguredError.rawValue,
              message: "Kaleyra Video SDK must be configured before performing this action")
    }
}
