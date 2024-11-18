// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import XCTest
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class AtomicTests: UnitTestCase {

    private var lock: FakeLock!
    private var sut: Atomic<Int>!

    override func setUpWithError() throws {
        try super.setUpWithError()

        lock = .init()
        sut = .init(42, lock: lock)
    }

    override func tearDownWithError() throws {
        sut = nil
        lock = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testValueShouldEnterACriticalSectionReadTheValueAndLeave() {
        let val = sut.wrappedValue

        assertThat(lock.lockInvocations, hasCount(1))
        assertThat(lock.unlockInvocations, hasCount(1))
        assertThat(val, equalTo(42))
    }

    func testSetValueShouldEnterACriticalSectionWriteTheValueAndLeave() {
        sut.wrappedValue = 1

        assertThat(lock.lockInvocations, hasCount(1))
        assertThat(lock.unlockInvocations, hasCount(1))
        assertThat(sut.wrappedValue, equalTo(1))
    }

    // MARK: - Do

    func testDoShouldExecuteTheGivenClosureInsideACriticalSection() {
        sut.do { value in
            assertThat(lock.lockInvocations, hasCount(1))
            assertThat(lock.unlockInvocations, empty())
            value = 1
        }

        assertThat(lock.unlockInvocations, hasCount(1))
        assertThat(sut.wrappedValue, equalTo(1))
    }

    func testDoShouldExecuteTheGivenClosureInACriticalSection() {
        let returnedValue = sut.do { value -> Int in
            assertThat(lock.lockInvocations, hasCount(1))
            assertThat(lock.unlockInvocations, empty())
            value = 1
            return 42
        }

        assertThat(lock.unlockInvocations, hasCount(1))
        assertThat(sut.wrappedValue, equalTo(1))
        assertThat(returnedValue, equalTo(42))
    }

    // MARK: - Swap

    func testSwapShouldChangeTheCurrentValueWithTheOneProvided() {
        let oldValue = sut.swap(1)

        assertThat(oldValue, equalTo(42))
        assertThat(sut.wrappedValue, equalTo(1))
    }

    func testSwapShouldChangeTheCurrentValueWithTheOneProvidedInsideACriticalSection() {
        _ = sut.swap(1)

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    // MARK: - Equatable

    func testEquatable() {
        let lock1 = makeFakeLock()
        let atomic1 = makeSUT(42, lock: lock1)
        let lock2 = makeFakeLock()
        let atomic2 = makeSUT(42, lock: lock2)

        assertThat(atomic1, equalTo(atomic2))
        assertThat(lock1.invocations, equalTo([.lock, .unlock]))
        assertThat(lock2.invocations, equalTo([.lock, .unlock]))
    }

    func testEqualToValue() {
        assertThat(sut == 42, isTrue())
        assertThat(42 == sut, isTrue())
    }

    func testEqualToValueLHSLocksCriticalSection() {
        _ = sut == 42

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testEqualToValueRHSLocksCriticalSection() {
        _ = 42 == sut

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    // MARK: - Addition

    func testAdditiveArithmeticLHSAddition() {
        sut += 1

        assertThat(sut == 43, isTrue())
    }

    func testAdditiveArithmeticInsideCriticalSectionLHSAddition() {
        sut += 1

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testAdditiveArithmeticRHSAddition() {
        var int = 1

        int += sut

        assertThat(int == 43, isTrue())
    }

    func testAdditiveArithmeticInsideCriticalSectionRHSAddition() {
        var int = 1

        int += sut

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testAdditiveArithmeticLHSSubtraction() {
        sut -= 1

        assertThat(sut == 41, isTrue())
    }

    func testAdditiveArithmeticInsideCriticalSectionLHSSubtraction() {
        sut -= 1

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testAdditiveArithmeticRHSSubtraction() {
        var int = 42

        int -= sut

        assertThat(int, equalTo(0))
    }

    func testAdditiveArithmeticInsideCriticalSectionRHSSubtraction() {
        var int = 42

        int -= sut

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    // MARK: - Collection

    func testCountShouldBeWrappedInACriticalSection() {
        let sut = makeSUT([1], lock: lock)

        _ = sut.count

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testCount() {
        let sut = makeSUT([1], lock: lock)

        assertThat(sut.count, equalTo(1))
    }

    func testIsEmptyShouldBeWrappedInACriticalSection() {
        let sut = makeSUT([1], lock: lock)

        _ = sut.isEmpty

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testIsEmpty() {
        assertThat(makeSUT([1]).isEmpty, isFalse())
        assertThat(makeSUT([Int]()).isEmpty, isTrue())
    }

    func testSubscriptRead() {
        assertThat(makeSUT([42])[0], equalTo(42))
    }

    func testSubscriptReadShouldBeWrappedInACriticalSection() {
        let sut = makeSUT([42], lock: lock)

        _ = sut[0]

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testDropFirst() {
        let sut = makeSUT([0, 1, 2, 3])

        let value = sut.dropFirst(3)

        assertThat(sut.wrappedValue, equalTo([0, 1, 2, 3]))
        assertThat(value, equalTo([3]))
    }

    func testDropFirstShouldBeWrappedInACriticalSection() {
        let sut = makeSUT([42], lock: lock)

        _ = sut.dropFirst()

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    func testDropLast() {
        let sut = makeSUT([0, 1, 2, 3])

        let value = sut.dropLast(2)

        assertThat(sut.wrappedValue, equalTo([0, 1, 2, 3]))
        assertThat(value, equalTo([0, 1]))
    }

    func testDropLastShouldBeWrappedInACriticalSection() {
        let sut = makeSUT([42], lock: lock)

        _ = sut.dropLast()

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    // MARK: - RangeReplacableCollection

    func testAppendShouldAppendValue() {
        let sut = makeSUT([0])

        sut.append(1)

        assertThat(sut.wrappedValue, equalTo([0, 1]))
    }

    func testAppendShouldAppendValueInACriticalSection() {
        let sut = makeSUT([0], lock: lock)

        sut.append(1)

        assertThat(lock.invocations, equalTo([.lock, .unlock]))
    }

    // MARK: - Projected value

    func testProjectedValueReturnsSelf() {
        assertThat(sut, sameInstance(sut.projectedValue))
    }

    // MARK: - Helpers

    private func makeSUT<Value>(_ value: Value, lock: Locking = FakeLock()) -> Atomic<Value> {
        .init(value, lock: lock)
    }

    private func makeFakeLock() -> FakeLock {
        .init()
    }
}

private class FakeLock: Locking {

    enum Invocation: CustomStringConvertible, Equatable {
        case lock
        case unlock

        var description: String {
            switch self {
                case .lock:
                    return "lock"
                case .unlock:
                    return "unlock"
            }
        }
    }

    private(set) var isLocked: Bool = false

    private(set) lazy var invocations = [Invocation]()

    var lockInvocations: [Void] {
        invocations.compactMap({ $0 == .lock ? () : nil })
    }

    var unlockInvocations: [Void] {
        invocations.compactMap({ $0 == .unlock ? () : nil  })
    }

    func sync<T>(_ work: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try work()
    }

    func lock() {
        invocations.append(.lock)
        isLocked = true
    }

    func unlock() {
        invocations.append(.unlock)
        isLocked = false
    }
}
