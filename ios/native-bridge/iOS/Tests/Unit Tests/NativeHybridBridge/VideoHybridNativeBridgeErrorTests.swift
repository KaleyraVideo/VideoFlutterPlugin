// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class VideoHybridNativeBridgeErrorTests: UnitTestCase {

    func testUnsupportedFunctionCallError() {
        let sut = VideoHybridNativeBridgeError.unsupportedFunctionCallError(method: "unsupported_function_name")

        assertThat(sut.code, equalTo("UNSUPPORTED_FUNCTION_CALL"))
        assertThat(sut.message, equalTo("Calling unsupported_function_name function is not supported"))
    }

    func testUnableToInitializeURLError() {
        let sut = VideoHybridNativeBridgeError.unableToInitializeURLError(urlString: "url_string")

        assertThat(sut.code, equalTo("INVALID_URL_ERROR"))
        assertThat(sut.message, equalTo("Unable to convert the provided string \"url_string\" to URL object"))
    }

    func testSdkNotConfiguredError() {
        let sut = VideoHybridNativeBridgeError.sdkNotConfiguredError()

        assertThat(sut.code, equalTo("SDK_NOT_CONFIGURED_ERROR"))
        assertThat(sut.message, equalTo("Kaleyra Video SDK must be configured before performing this action"))
    }
}
