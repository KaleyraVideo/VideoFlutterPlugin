// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

class UsersDetailsCache {

    private lazy var items = [String : KaleyraVideoSDK.UserDetails]()
    private let lock: Locking = NSRecursiveLock()

    func setItem(_ item: KaleyraVideoSDK.UserDetails, forKey key: String) {
        lock.sync {
            items[key] = item
        }
    }

    func setItems(_ items: [KaleyraVideoSDK.UserDetails]) {
        lock.sync {
            items.forEach { setItem($0, forKey: $0.userId) }
        }
    }

    func item(forKey key: String) -> KaleyraVideoSDK.UserDetails? {
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
