// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 11.0, *)
class AccessTokenRequest_EncodableTests: UnitTestCase {

    private var encoder: JSONEncoder!

    override func setUpWithError() throws {
        try super.setUpWithError()

        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }

    override func tearDownWithError() throws {
        encoder = nil

        try super.tearDownWithError()
    }

    func testEncodesAsJson() throws {
        let sut = AccessTokenRequest(requestID: "request id", userID: "alice")

        let json = try encode(sut)

        let expectedJson = """
        {
          "requestID" : "request id",
          "userID" : "alice"
        }
        """
        assertThat(json, equalTo(expectedJson))
    }

    // MARK: - Helpers

    private func encode<T: Encodable>(_ value: T) throws -> String {
        let data = try encoder.encode(value)
        return String(data: data, encoding: .utf8)!
    }
}
