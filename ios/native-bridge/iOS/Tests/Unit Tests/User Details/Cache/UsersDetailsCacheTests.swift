// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class UsersDetailsCacheTests: UnitTestCase, UserDetailsFixtureFactory {

    private var sut: UsersDetailsCache!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .init()
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testSetsItem() {
        let item = makeItem(userID: "bob", firstname: "Robert", lastname: "Appleseed")

        sut.setItem(item, forKey: item.userID)

        let storedItem = sut.item(forKey: item.userID)
        assertThat(storedItem, equalTo(item))
    }

    func testPurgesAllItems() {
        let item1 = makeItem(userID: "user1")
        let item2 = makeItem(userID: "user2")
        let item3 = makeItem(userID: "user3")
        sut.setItem(item1, forKey: "user1")
        sut.setItem(item2, forKey: "user2")
        sut.setItem(item3, forKey: "user3")

        sut.purge()

        assertThat(sut.item(forKey: "user1"), nilValue());
        assertThat(sut.item(forKey: "user2"), nilValue());
        assertThat(sut.item(forKey: "user3"), nilValue());
    }

}
