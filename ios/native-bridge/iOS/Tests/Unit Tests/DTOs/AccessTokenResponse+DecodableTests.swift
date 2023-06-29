// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class AccessTokenResponse_DecodableTests: UnitTestCase, JSONDecodingTestCase {

    typealias SUT = AccessTokenResponse

    func testDecodesValidResponse() throws {
        let json = """
        {
            "success" : true,
            "requestID" : "request id",
            "data" : "some data",
            "error" : null
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.requestID, equalTo("request id"))
        assertThat(decoded.success, isTrue())
        assertThat(decoded.data, equalTo("some data"))
        assertThat(decoded.error, nilValue())
    }

    func testDecodesValidResponseWithUnsuccessfulState() throws {
        let json = """
        {
            "success" : false,
            "requestID" : "request id",
            "data" : "",
            "error" : "some error"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.requestID, equalTo("request id"))
        assertThat(decoded.success, isFalse())
        assertThat(decoded.data, equalTo(""))
        assertThat(decoded.error, equalTo("some error"))
    }

}
