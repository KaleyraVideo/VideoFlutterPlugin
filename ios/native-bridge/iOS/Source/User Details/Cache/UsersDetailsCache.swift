// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class UsersDetailsCache {

    private lazy var items = [String : Bandyer.UserDetails]()
    private let lock: Lock = NSRecursiveLock()

    func setItem(_ item: Bandyer.UserDetails, forKey key: String) {
        lock.sync {
            items[key] = item
        }
    }

    func setItems(_ items: [Bandyer.UserDetails]) {
        lock.sync {
            items.forEach { setItem($0, forKey: $0.userID) }
        }
    }

    func item(forKey key: String) -> Bandyer.UserDetails? {
        lock.sync {
            items[key]
        }
    }

    func purge() {
        lock.sync {
            items.removeAll()
        }
    }
}
