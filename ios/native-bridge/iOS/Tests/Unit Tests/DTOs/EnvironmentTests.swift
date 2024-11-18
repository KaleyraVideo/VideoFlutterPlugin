// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

class EnvironmentTests: UnitTestCase {

    func testBandyerEnvironment() {
        assertThat(Environment(name: "production").kaleyraEnvironment, equalTo(.production))
        assertThat(Environment(name: "PRODUCTION").kaleyraEnvironment, equalTo(.production))
        assertThat(Environment(name: "ProDUCtioN").kaleyraEnvironment, equalTo(.production))
        assertThat(Environment(name: "sandbox").kaleyraEnvironment, equalTo(.sandbox))
        assertThat(Environment(name: "SANDBOX").kaleyraEnvironment, equalTo(.sandbox))
        assertThat(Environment(name: "sAndBoX").kaleyraEnvironment, equalTo(.sandbox))
    }

}
