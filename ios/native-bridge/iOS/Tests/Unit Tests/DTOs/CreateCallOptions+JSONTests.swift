// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class CreateCallOptions_JSONTests: UnitTestCase {

    func testDecodesJSON() throws {
        let json = """
        {
            "callees" : ["alice", "bob"],
            "callType" : "audio",
            "recordingType" : "automatic"
        }
        """

        let decoded = try CreateCallOptions.decodeJSON(json)

        assertThat(decoded.callees, equalTo(["alice", "bob"]))
        assertThat(decoded.callType, equalTo(.audio))
        assertThat(decoded.recordingType, presentAnd(equalTo(.automatic)))
    }

}
