// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class Tools_DecodableTests: UnitTestCase, JSONDecodingTestCase {

    typealias SUT = Tools

    func testDecodesValidValue() throws {
        let json = """
        {
            "chat" : {
                "audioCallOption" : {
                    "type" : "audio",
                    "recordingType" : "automatic"
                },
                "videoCallOption" : {
                    "recordingType" : "automatic"
                }
            },
            "fileShare" : false,
            "whiteboard" : true,
            "screenShare" : {
                "inApp" : true,
                "wholeDevice" : false
            },
            "feedback" : true
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.chat?.videoCallOption?.recordingType, presentAnd(equalTo(.automatic)))
        assertThat(decoded.chat?.audioCallOption?.type, presentAnd(equalTo(.audio)))
        assertThat(decoded.chat?.audioCallOption?.recordingType, presentAnd(equalTo(.automatic)))
        assertThat(decoded.fileShare, presentAnd(isFalse()))
        assertThat(decoded.whiteboard, presentAnd(isTrue()))
        assertThat(decoded.screenShare?.inApp, presentAnd(isTrue()))
        assertThat(decoded.screenShare?.wholeDevice, presentAnd(isFalse()))
        assertThat(decoded.feedback, presentAnd(isTrue()))
    }

    func testDecodesValidValueSettingMissingValuesToDefaults() throws {
        let json = """
        {
            "fileShare" : false,
            "screenShare" : {
                "wholeDevice" : false
            }
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.chat, nilValue())
        assertThat(decoded.fileShare, presentAnd(isFalse()))
        assertThat(decoded.whiteboard, presentAnd(isFalse()))
        assertThat(decoded.screenShare?.inApp, presentAnd(isFalse()))
        assertThat(decoded.screenShare?.wholeDevice, presentAnd(isFalse()))
        assertThat(decoded.feedback, presentAnd(isFalse()))
    }

}
