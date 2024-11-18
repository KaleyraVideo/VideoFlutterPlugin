// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import CallKit
import Hamcrest
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

class UsersDetailsProviderTests: UnitTestCase {

    private let alice = UserDetails(userId: "alice", name: "Alice Appleseed")
    private let bob = UserDetails(userId: "bob", name: "Bob Appleseed")
    private let charlie = UserDetails(userId: "charlie", name: "Charlie Appleseed")
    private let emily = UserDetails(userId: "emily")

    // MARK: - Tests

    func testFetchesUsersDetailsFromCache() {
        let cache = makePopulatedCache()
        let sut = makeSUT(cache: cache)

        let completionSpy = makeCompletionDetailsSpy()
        sut.provideDetails(["alice", "bob"], completion: completionSpy.callable(_:))
        
        assertThat(completionSpy.invocations, hasCount(1))
        assertThat(try? completionSpy.invocations.first?.get(), presentAnd(equalTo([alice, bob])))
    }

    func testCreatesItemWhenOneCouldNotBeFoundInTheCache() {
        let cache = makePopulatedCache()
        let sut = makeSUT(cache: cache)

        let completionSpy = makeCompletionDetailsSpy()
        sut.provideDetails(["alice", "dave"], completion: completionSpy.callable(_:))

        let missingItem = UserDetails(userId: "dave")
        assertThat(completionSpy.invocations, hasCount(1))
        assertThat(try? completionSpy.invocations.first?.get(), presentAnd(equalTo([alice, missingItem])))
    }

    // MARK: - Helpers

    private func makePopulatedCache() -> UsersDetailsCache {
        let cache = UsersDetailsCache()
        cache.setItem(alice, forKey: "alice")
        cache.setItem(bob, forKey: "bob")
        cache.setItem(charlie, forKey: "charlie")
        cache.setItem(emily, forKey: "emily")
        return cache
    }

    private func makeSUT(cache: UsersDetailsCache) -> UsersDetailsProvider {
        .init(cache: cache)
    }

    private func makeCompletionDetailsSpy() -> CompletionSpy<Result<[KaleyraVideoSDK.UserDetails], any Error>> {
        makeCompletionSpy()
    }

    private func makeCompletionHandleSpy() -> CompletionSpy<CXHandle> {
        makeCompletionSpy()
    }

    private func makeCompletionSpy<T>() -> CompletionSpy<T> {
        .init()
    }

    // MARK: - Doubles

    private class NilFormatter: Formatter {

        override func string(for obj: Any?) -> String? {
            nil
        }
    }
}
