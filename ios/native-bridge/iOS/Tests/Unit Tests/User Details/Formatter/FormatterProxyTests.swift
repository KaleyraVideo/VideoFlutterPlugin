// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class FormatterProxyTests: UnitTestCase, UserDetailsFixtureFactory {

    private var sut: FormatterProxy!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init()
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testStringForObjectValueShouldReturnAFormattedStringProvidedByTheFallbackFormatter() {
        let item = makeItem(userID: "bob")

        let string = sut.string(for: item)

        assertThat(string, equalTo(item.userID));
    }

    func testStringForObjectValueShouldReturnAFormattedStringProvidedByTheProxeeFormatter() {
        let realFormatter = UserDetailsFormatter(format: "${firstname} ${lastname}")
        sut.formatter = realFormatter;

        let item = makeItem(userID: "bob")
        let string = sut.string(for: item)

        assertThat(string, equalTo(realFormatter.string(for: item)))
    }

    func testSetNilFormatterShouldSetDefaultFormatter() {
        let realFormatter = UserDetailsFormatter(format: "${firstname} ${lastname}")
        sut.formatter = realFormatter;

        sut.formatter = nil

        let item = makeItem(userID: "bob")
        let string = sut.string(for: item)
        assertThat(string, equalTo(item.userID));
    }
}
