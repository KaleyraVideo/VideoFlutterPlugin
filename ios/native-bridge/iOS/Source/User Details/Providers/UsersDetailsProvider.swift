// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import CallKit
import KaleyraVideoSDK

class UsersDetailsProvider: NSObject, UserDetailsProvider {

    private let cache: UsersDetailsCache

    init(cache: UsersDetailsCache) {
        self.cache = cache
        super.init()
    }

    func provideDetails(_ userIds: [String], completion: @escaping (Result<[KaleyraVideoSDK.UserDetails], any Error>) -> Void) {
        completion(.success(detailsFor(userIds: userIds)))
    }

    private func detailsFor(userIds: [String]) -> [KaleyraVideoSDK.UserDetails] {
        userIds.map { id in
            cache.item(forKey: id) ?? .init(userId: id)
        }
    }
}
