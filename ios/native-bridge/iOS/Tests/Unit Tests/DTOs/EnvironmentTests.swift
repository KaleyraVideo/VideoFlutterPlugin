// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class EnvironmentTests: UnitTestCase {

    func testBandyerEnvironment() {
        assertThat(Environment(name: "production").bandyerEnvironment, equalTo(.production))
        assertThat(Environment(name: "PRODUCTION").bandyerEnvironment, equalTo(.production))
        assertThat(Environment(name: "ProDUCtioN").bandyerEnvironment, equalTo(.production))
        assertThat(Environment(name: "sandbox").bandyerEnvironment, equalTo(.sandbox))
        assertThat(Environment(name: "SANDBOX").bandyerEnvironment, equalTo(.sandbox))
        assertThat(Environment(name: "sAndBoX").bandyerEnvironment, equalTo(.sandbox))
    }

}
