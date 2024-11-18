// Copyright © 2018-2024 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class UserDetails_DecodableTests: UnitTestCase, JSONDecodingTestCase {
 
    typealias SUT = UserDetails

    func testDecodesValidJSON() throws {
        let json = """
        {
            "userID" : "usr_12345",
            "name" : "John Appleseed",
            "imageUrl" : "https://www.kaleyra.com"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.userID, equalTo("usr_12345"))
        assertThat(decoded.name, presentAnd(equalTo("John Appleseed")))
        assertThat(decoded.imageURL, presentAnd(equalTo("https://www.kaleyra.com")))
    }

    func testDecodesWhenMissingUserIDShouldThrowAnError() throws {
        let json = """
        {
            "name" : "John Appleseed",
            "imageUrl" : "https://www.kaleyra.com"
        }
        """

        assertThrows(try decode(json))
    }

    func testDecodesWhenMissingName() throws {
        let json = """
        {
            "userID" : "usr_12345",
            "imageUrl" : "https://www.kaleyra.com"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.userID, equalTo("usr_12345"))
        assertThat(decoded.name, nilValue())
        assertThat(decoded.imageURL, presentAnd(equalTo("https://www.kaleyra.com")))
    }

    func testDecodesWhenMissingImageUrl() throws {
        let json = """
        {
            "userID" : "usr_12345",
            "name" : "John Appleseed"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.userID, equalTo("usr_12345"))
        assertThat(decoded.name, presentAnd(equalTo("John Appleseed")))
        assertThat(decoded.imageURL, nilValue())
    }
}
