// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class URL_FromStringTests: UnitTestCase {

    func testURLFromStringShouldReturnAURLInitializedUsingProvidedString() throws {
        let urlString = "https://www.kaleyra.com"

        let url = try URL.fromString(urlString)

        assertThat(url.absoluteString, equalTo(urlString))
    }

    func testURLFromStringWithMalformedUrlStringShouldThrowAnException() {
        let malformedUrlString = "htt s://§#@Malformed!{"

        assertThrows(try URL.fromString(malformedUrlString), equalTo(VideoHybridNativeBridgeError.unableToInitializeURLError(urlString: malformedUrlString)))
    }

    func testURLFromStringShouldReturnAURLInitializedUnsescapingProvidedString() throws {
        let urlString = "\"https://www.kaleyra.com\""
        let expected = "https://www.kaleyra.com"

        let url = try URL.fromString(urlString)

        assertThat(url.absoluteString, equalTo(expected))
    }
}
