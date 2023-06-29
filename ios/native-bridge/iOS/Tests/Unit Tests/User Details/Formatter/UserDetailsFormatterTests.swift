// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class UserDetailsFormatterTests: UnitTestCase, UserDetailsFixtureFactory {

    func testReturnsUserName() {
        let sut = makeSUT(format: "${firstName}")
        let item = makeItem(userID: "bob", firstname: "Bob", lastname: nil)

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob"))
    }

    func testReturnsNilWhenUnknownItemIsProvidedAsArgument() {
        let sut = makeSUT(format: "${firstName}")

        let string = sut.string(for: self)

        assertThat(string, nilValue());
    }

    func testReturnsUserIDWhenFormatContainsUserAlias() {
        let sut = makeSUT(format: "${useralias}")
        let item = makeItem(userID: "bob")

        let string = sut.string(for: item)

        assertThat(string, equalTo("bob"))
    }

    func testReturnsUserIDWhenFormatContainsUserID() {
        let sut = makeSUT(format: "${userid}")
        let item = makeItem(userID: "bob")

        let string = sut.string(for: item)

        assertThat(string, equalTo("bob"))
    }

    func testReturnsUserLastName()
    {
        let sut = makeSUT(format: "${lastName}")
        let item = makeItem(userID: "bob", firstname: nil, lastname: "Appleseed")

        let string = sut.string(for: item)

        assertThat(string, equalTo("Appleseed"))
    }

    func testReturnsUserEmail()
    {
        let sut = makeSUT(format: "${email}")
        let item = makeItem(userID: "bob", email: "bob.appleseed@acme.com")

        let string = sut.string(for: item)

        assertThat(string, equalTo("bob.appleseed@acme.com"))
    }

    func testReturnsUserNickname()
    {
        let sut = makeSUT(format: "${nickname}")
        let item = makeItem(userID: "bob", nickname: "Bob")

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob"))
    }

    func testReturnsUserFullname()
    {
        let sut = makeSUT(format: "${firstName} ${lastName}")
        let item = makeItem(userID: "bob", firstname: "Bob", lastname: "Appleseed")

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob Appleseed"))
    }

    func testPreservesWhitespacesBetweenTokens()
    {
        let sut = makeSUT(format: "${firstName}     ${lastName}")
        let item = makeItem(userID: "bob", firstname: "Bob", lastname: "Appleseed")

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob     Appleseed"))
    }

    func testPreservesAnyCharacterBetweenTokens()
    {
        let sut = makeSUT(format: "${firstName} - + / . $ ${lastName}")
        let item = makeItem(userID: "bob", firstname: "Bob", lastname: "Appleseed")

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob - + / . $ Appleseed"))
    }

    func testMatchesAreInsensitiveToCase()
    {
        let sut = makeSUT(format: "${fIrStNaME} ${LasTNAmE}")
        let item = makeItem(userID: "bob", firstname: "Bob", lastname: "Appleseed")

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob Appleseed"))
    }

    func testReturnsSentence()
    {
        let sut = makeSUT(format: "Hello my name is: ${firstName} ${lastName}, friends call me ${nickname}")
        let item = makeItem(userID: "bob", firstname: "Robert", lastname: "Appleseed", email: nil, nickname: "Bob")

        let string = sut.string(for: item)

        assertThat(string, equalTo("Hello my name is: Robert Appleseed, friends call me Bob"))
    }

    func testPrintsOutUnknownToken()
    {
        let sut = makeSUT(format: "${firstname} ${unknown}")
        let item = makeItem(userID: "bob", firstname: "Bob", lastname: nil)

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob ${unknown}"))
    }

    func testNilValueReplacesTokenWithEmptyStringTrimmingTrailingWhitespaces()
    {
        let sut = makeSUT(format: "${firstname} ${lastname}")
        let item = makeItem(userID: "bob", firstname: "Bob", lastname: nil)

        let string = sut.string(for: item)

        assertThat(string, equalTo("Bob"))
    }

    func testReplacesTokensForEveryItemInTheArrayJoiningTheReplacedStringsWithAComma()
    {
        let sut = makeSUT(format: "${firstname} ${lastname}")
        let firstItem = makeItem(userID: "bob", firstname: "Bob", lastname: "Appleseed")
        let secondItem = makeItem(userID: "jane", firstname: "Jane", lastname: "Appleseed")
        let items = [firstItem, secondItem]

        let string = sut.string(for: items)

        assertThat(string, equalTo("Bob Appleseed, Jane Appleseed"))
    }

    func testStringForObjectValueShouldReturnNilWhenAnHeterogeneousArrayIsProvided()
    {
        let sut = makeSUT(format: "${firstname} ${lastname}")
        let firstItem = makeItem(userID: "alias", firstname: "Bob", lastname: "Appleseed")
        let items = [firstItem, "foreign item"] as [Any]

        let string = sut.string(for: items)

        assertThat(string, nilValue())
    }

    func testReturnsUserAliasWhenNoneOfTheTokensCanBeReplacedBecauseTheItemDoesNotProvideAnyValueForTheTokensDefinedInTheFormat()
    {
        let sut = makeSUT(format: "${firstname} ${lastname}")
        let item = makeItem(userID: "alias")

        let string = sut.string(for: [item])

        assertThat(string, equalTo(item.userID));
    }

    // MARK: - Helpers

    private func makeSUT(format: String) -> UserDetailsFormatter {
        .init(format: format)
    }
}
