// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

protocol Locking {

    func sync<T>(_ work: () throws -> T) rethrows -> T
}

extension Locking where Self: NSLocking {

    func sync<T>(_ work: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try work()
    }
}

extension NSLock: Locking {}
extension NSRecursiveLock: Locking {}
