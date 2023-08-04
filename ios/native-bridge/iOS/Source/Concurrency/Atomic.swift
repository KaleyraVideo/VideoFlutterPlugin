// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@propertyWrapper
class Atomic<Value> {

    private var value: Value
    private let lock: Locking

    init(wrappedValue: Value, lock: Locking = NSLock()) {
        self.value = wrappedValue
        self.lock = lock
    }

    init(_ value: Value, lock: Locking = NSLock()) {
        self.value = value
        self.lock = lock
    }

    var wrappedValue: Value {
        get {
            lock.sync {
                value
            }
        }

        set {
            lock.sync {
                value = newValue
            }
        }
    }

    var projectedValue: Atomic<Value> { self }

    func `do`(_ body: (inout Value) throws -> Void) rethrows {
        try lock.sync { try body(&value) }
    }

    func `do`<T>(_ body: (inout Value) throws -> T) rethrows -> T {
        try lock.sync { try body(&value) }
    }

    func swap(_ newValue: Value) -> Value {
        lock.sync {
            let oldValue = value
            value = newValue
            return oldValue
        }
    }
}

extension Atomic: Equatable where Value: Equatable {

    static func == (lhs: Atomic<Value>, rhs: Atomic<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Atomic where Value: Equatable {

    static func == (lhs: Atomic<Value>, rhs: Value) -> Bool {
        lhs.wrappedValue == rhs
    }

    static func == (lhs: Value, rhs: Atomic<Value>) -> Bool {
        lhs == rhs.wrappedValue
    }
}

extension Atomic where Value: AdditiveArithmetic {

    static func += (lhs: Atomic<Value>, rhs: Value) {
        lhs.do { $0 += rhs }
    }

    static func += (lhs: inout Value, rhs: Atomic<Value>) {
        lhs += rhs.wrappedValue
    }

    static func -= (lhs: Atomic<Value>, rhs: Value) {
        lhs.do { $0 -= rhs }
    }

    static func -= (lhs: inout Value, rhs: Atomic<Value>) {
        lhs -= rhs.wrappedValue
    }
}

extension Atomic where Value: Collection {

    var count: Int { wrappedValue.count }

    var isEmpty: Bool { wrappedValue.isEmpty }

    subscript(index: Value.Index) -> Value.Element {
        wrappedValue[index]
    }

    func dropFirst(_ k: Int = 1) -> Value.SubSequence {
        wrappedValue.dropFirst(k)
    }

    func dropLast(_ k: Int = 1) -> Value.SubSequence {
        wrappedValue.dropLast(k)
    }
}

extension Atomic where Value: RangeReplaceableCollection {

    func append(_ newElement: Value.Element) {
        self.do { $0.append(newElement) }
    }
}
