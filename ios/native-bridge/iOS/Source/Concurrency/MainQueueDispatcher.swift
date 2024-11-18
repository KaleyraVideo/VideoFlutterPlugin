// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

public enum MainQueueDispatcher {

    public static func perform(_ work: @escaping () -> Void) {
        guard DispatchQueue.isMain else {
            return DispatchQueue.main.async(execute: work)
        }

        work()
    }

    public static func performSync<T>(_ work: () -> T) -> T {
        guard DispatchQueue.isMain else {
            return DispatchQueue.main.sync(execute: work)
        }
        return work()
    }
}
