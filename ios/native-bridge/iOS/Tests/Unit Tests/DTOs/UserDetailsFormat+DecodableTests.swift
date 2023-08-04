// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class UserDetailsFormat_DecodableTests: UnitTestCase, JSONDecodingTestCase {

    typealias SUT = UserDetailsFormat

    func testDecodesValidJSON() throws {
        let json = """
        {
            "default" : "${a} ${b}"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.userDetailsFormatDefault, equalTo("${a} ${b}"))
    }

    func testThrowsAnErrorWhenFormatIsMissing() throws {
        let json = """
        {
            "foo" : "${a} ${b}"
        }
        """

        assertThrows(try decode(json))
    }
}
