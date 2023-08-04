// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class RegionTests: UnitTestCase {

    func testBandyerRegion() {
        assertThat(Region(name: "europe").bandyerRegion, equalTo(.europe))
        assertThat(Region(name: "EUROPE").bandyerRegion, equalTo(.europe))
        assertThat(Region(name: "eUrOPE").bandyerRegion, equalTo(.europe))
        assertThat(Region(name: "eu").bandyerRegion, equalTo(.europe))
        assertThat(Region(name: "EU").bandyerRegion, equalTo(.europe))
        assertThat(Region(name: "india").bandyerRegion, equalTo(.india))
        assertThat(Region(name: "INDIA").bandyerRegion, equalTo(.india))
        assertThat(Region(name: "InDIa").bandyerRegion, equalTo(.india))
        assertThat(Region(name: "in").bandyerRegion, equalTo(.india))
        assertThat(Region(name: "IN").bandyerRegion, equalTo(.india))
        assertThat(Region(name: "us").bandyerRegion, equalTo(.us))
        assertThat(Region(name: "US").bandyerRegion, equalTo(.us))
        assertThat(Region(name: "uS").bandyerRegion, equalTo(.us))
        assertThat(Region(name: "usa").bandyerRegion, equalTo(.us))
        assertThat(Region(name: "USA").bandyerRegion, equalTo(.us))
        assertThat(Region(name: "UsA").bandyerRegion, equalTo(.us))
    }
}
