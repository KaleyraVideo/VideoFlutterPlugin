// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class CreateCallOptions_DecodableTests: UnitTestCase, JSONDecodingTestCase {

    typealias SUT = CreateCallOptions

    func testDecodesDictionaryContainingBothMandatoryAndOptionalValues() throws {
        let json = """
        {
            "callees" : ["alice", "bob"],
            "callType" : "audio",
            "recordingType" : "automatic"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.callees, equalTo(["alice", "bob"]))
        assertThat(decoded.callType, equalTo(.audio))
        assertThat(decoded.recordingType, presentAnd(equalTo(.automatic)))
    }

    func testDecodesDictionaryMissingRecordingTypeUsingADefaultValue() throws {
        let json = """
        {
            "callees" : ["alice", "bob"],
            "callType" : "audio"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.callees, equalTo(["alice", "bob"]))
        assertThat(decoded.callType, equalTo(.audio))
        assertThat(decoded.recordingType, presentAnd(equalTo(.none)))
    }

    func testThrowsAnErrorWhenAnUnknownCallTypeIsProvided() throws {
        let json = """
        {
            "callees" : ["alice", "bob"],
            "callType" : "foo",
            "recordingType" : "automatic"
        }
        """

        assertThrows(try decode(json))
    }

    func testThrowsAnErrorWhenARecordingTypeIsProvided() throws {
        let json = """
        {
            "callees" : ["alice", "bob"],
            "callType" : "audioVideo",
            "recordingType" : "foo"
        }
        """

        assertThrows(try decode(json))
    }
}
