// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import CallKit
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
class UsersDetailsProviderTests: UnitTestCase {

    private let alice = UserDetails(userID: "alice", firstname: "Alice", lastname: "Appleseed")
    private let bob = UserDetails(userID: "bob", firstname: "Bob", lastname: "Appleseed")
    private let charlie = UserDetails(userID: "charlie", firstname: "Charlie", lastname: "Appleseed")
    private let emily = UserDetails(userID: "emily")

    // MARK: - Tests

    func testFetchesUsersDetailsFromCache() {
        let cache = makePopulatedCache()
        let sut = makeSUT(cache: cache, formatter: .init())

        let completionSpy = makeCompletionDetailsSpy()
        sut.provideDetails(["alice", "bob"], completion: completionSpy.callable(_:))
        
        assertThat(completionSpy.invocations, equalTo([[alice, bob]]))
    }

    func testCreatesItemWhenOneCouldNotBeFoundInTheCache() {
        let cache = makePopulatedCache()
        let sut = makeSUT(cache: cache, formatter: .init())

        let completionSpy = makeCompletionDetailsSpy()
        sut.provideDetails(["alice", "dave"], completion: completionSpy.callable(_:))

        let missingItem = UserDetails(userID: "dave")
        assertThat(completionSpy.invocations, equalTo([[alice, missingItem]]))
    }

    func testCreatesGenericHandleWithValueFormattedByTheFormatterProvidedInInitialization() {
        let cache = makePopulatedCache()
        let formatter = makeDetailsFormatter()
        let sut = makeSUT(cache: cache, formatter: formatter)

        let completionSpy = makeCompletionHandleSpy()
        sut.provideHandle(["alice"], completion: completionSpy.callable(_:))

        assertThat(completionSpy.invocations, equalTo([.init(type: .generic, value: "Alice Appleseed")]))
    }

    func testCreatesGenericContactHandleWhenItemIsMissingFromCache() {
        let cache = makePopulatedCache()
        let formatter = makeDetailsFormatter()
        let sut = makeSUT(cache: cache, formatter: formatter)

        let completionSpy = makeCompletionHandleSpy()
        sut.provideHandle(["missing"], completion: completionSpy.callable(_:))

        assertThat(completionSpy.invocations, equalTo([.init(type: .generic, value: "missing")]))
    }

    func testCreatesGenericContactHandleWithAliasAsHandleValueWhenItemIsMissingTheRequestedValues() {
        let cache = makePopulatedCache()
        let formatter = makeDetailsFormatter()
        let sut = makeSUT(cache: cache, formatter: formatter)

        let completionSpy = makeCompletionHandleSpy()
        sut.provideHandle(["emily"], completion: completionSpy.callable(_:))

        assertThat(completionSpy.invocations, equalTo([.init(type: .generic, value: "emily")]))
    }

    func testCreatesGenericContactHandleConcatenatingItemsFullnamesAsHandleValue() {
        let cache = makePopulatedCache()
        let formatter = makeDetailsFormatter()
        let sut = makeSUT(cache: cache, formatter: formatter)

        let completionSpy = makeCompletionHandleSpy()
        sut.provideHandle(["alice", "bob"], completion: completionSpy.callable(_:))

        assertThat(completionSpy.invocations, equalTo([.init(type: .generic, value: "Alice Appleseed, Bob Appleseed")]))
    }

    func testCreatesEmptyContactHandleWhenEmptyAliasesArrayIsProvided() {
        let cache = makePopulatedCache()
        let formatter = makeDetailsFormatter()
        let sut = makeSUT(cache: cache, formatter: formatter)

        let completionSpy = makeCompletionHandleSpy()
        sut.provideHandle([], completion: completionSpy.callable(_:))

        assertThat(completionSpy.invocations, equalTo([.init(type: .generic, value: "")]))
    }

    func testCreatesContactHandleConcatenatingUserIdsWhenNilFormattedStringIsProvided() {
        let cache = makePopulatedCache()
        let formatter = makeNilFormatter()
        let sut = makeSUT(cache: cache, formatter: formatter)

        let completionSpy = makeCompletionHandleSpy()
        sut.provideHandle(["alice", "dave"], completion: completionSpy.callable(_:))

        assertThat(completionSpy.invocations, equalTo([.init(type: .generic, value: "alice, dave")]))
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

    private func makeSUT(cache: UsersDetailsCache, formatter: Formatter) -> UsersDetailsProvider {
        .init(cache: cache, formatter: formatter)
    }

    private func makeDetailsFormatter(format: String = "${firstname} ${lastname}") -> UserDetailsFormatter {
        .init(format: format)
    }

    private func makeNilFormatter() -> NilFormatter {
        .init()
    }

    private func makeCompletionDetailsSpy() -> CompletionSpy<[Bandyer.UserDetails]> {
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
