// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

class IosConfiguration_DecodableTests: UnitTestCase, JSONDecodingTestCase {

    typealias SUT = IosConfiguration

    func testDecodesValidValue() throws {
        let json = """
        {
            "callkit" : {
                "enabled" : true,
                "appIconName" : "appIcon",
                "ringtoneSoundName" : "ringtone"
            },
            "voipHandlingStrategy" : "automatic"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.callkit?.enabled, presentAnd(isTrue()))
        assertThat(decoded.callkit?.appIconName, presentAnd(equalTo("appIcon")))
        assertThat(decoded.callkit?.ringtoneSoundName, presentAnd(equalTo("ringtone")))
        assertThat(decoded.voipHandlingStrategy, presentAnd(equalTo(.automatic)))
    }

    func testDecodesValidValueSettingOptionalValuesToDefaults() throws {
        let json = """
        {
            "foo" : "bar"
        }
        """

        let decoded = try decode(json)

        assertThat(decoded.callkit?.enabled, presentAnd(isTrue()))
    }
}
