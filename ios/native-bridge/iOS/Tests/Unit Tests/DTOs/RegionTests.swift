// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

class RegionTests: UnitTestCase {

    func testBandyerRegion() {
        assertThat(Region(name: "europe").kaleyraRegion, equalTo(.europe))
        assertThat(Region(name: "EUROPE").kaleyraRegion, equalTo(.europe))
        assertThat(Region(name: "eUrOPE").kaleyraRegion, equalTo(.europe))
        assertThat(Region(name: "eu").kaleyraRegion, equalTo(.europe))
        assertThat(Region(name: "EU").kaleyraRegion, equalTo(.europe))
        assertThat(Region(name: "india").kaleyraRegion, equalTo(.india))
        assertThat(Region(name: "INDIA").kaleyraRegion, equalTo(.india))
        assertThat(Region(name: "InDIa").kaleyraRegion, equalTo(.india))
        assertThat(Region(name: "in").kaleyraRegion, equalTo(.india))
        assertThat(Region(name: "IN").kaleyraRegion, equalTo(.india))
        assertThat(Region(name: "us").kaleyraRegion, equalTo(.us))
        assertThat(Region(name: "US").kaleyraRegion, equalTo(.us))
        assertThat(Region(name: "uS").kaleyraRegion, equalTo(.us))
        assertThat(Region(name: "usa").kaleyraRegion, equalTo(.us))
        assertThat(Region(name: "USA").kaleyraRegion, equalTo(.us))
        assertThat(Region(name: "UsA").kaleyraRegion, equalTo(.us))
    }
}
