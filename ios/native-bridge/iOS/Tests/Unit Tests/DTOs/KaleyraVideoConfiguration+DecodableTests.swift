// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class KaleyraVideoConfiguration_DecodableTests: UnitTestCase, JSONDecodingTestCase {

    typealias SUT = KaleyraVideoConfiguration

    func testDecodesValidObjectWhenRepresentationContainsMandatoryAndOptionalValues() throws {
        let json = """
        {
            "appID" : "abcdef",
            "environment" : {
                "name" : "sandbox"
            },
            "region" : {
                "name" : "europe"
            },
            "iosConfig" : {
                "callkit" : {
                    "enabled" : true,
                    "appIconName" : "appIcon",
                    "ringtoneSoundName" : "ringtone"
                }
            },
            "logEnabled" : true,
            "tools" : {
                "chat" : {
                    "audioCallOption" : {
                        "type" : "audioUpgradable",
                        "recordingType" : "manual"
                    },
                    "videoCallOption" : {
                        "recordingType" : "none"
                    }
                },
                "fileShare" : true,
                "whiteboard" : true,
                "screenShare" : {
                    "inApp" : true,
                    "wholeDevice": false
                }
            }
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.appID, equalTo("abcdef"))
        assertThat(decoded.environment.name, equalTo("sandbox"))
        assertThat(decoded.region.name, equalTo("europe"))
        assertThat(decoded.logEnabled, presentAnd(isTrue()))
        assertThat(decoded.iosConfig, present())
        assertThat(decoded.tools, present())
    }

    func testDecodesValidObjectSettingMissingValuesToDefaults() throws {
        let json = """
        {
            "appID" : "abcdef",
            "environment" : {
                "name" : "sandbox"
            },
            "region" : {
                "name" : "europe"
            }
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.appID, equalTo("abcdef"))
        assertThat(decoded.environment.name, equalTo("sandbox"))
        assertThat(decoded.region.name, equalTo("europe"))
        assertThat(decoded.logEnabled, presentAnd(isFalse()))
        assertThat(decoded.iosConfig, nilValue())
        assertThat(decoded.tools, nilValue())
    }

    func testThrowsDecodingErrorWhenMandatoryValueIsMissing() throws {
        let json = """
        {
            "appID" : "abcdef",
            "environment" : {
                "name" : "sandbox"
            }
        }
        """

        assertThrows(try decode(json))
    }
}
