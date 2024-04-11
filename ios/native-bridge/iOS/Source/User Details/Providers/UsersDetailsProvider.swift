// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import CallKit
import Bandyer

@available(iOS 12.0, *)
class UsersDetailsProvider: NSObject, UserDetailsProvider {

    private let cache: UsersDetailsCache
    private let formatter: Formatter

    init(cache: UsersDetailsCache, formatter: Formatter) {
        self.cache = cache
        self.formatter = formatter
        super.init()
    }

    func provideDetails(_ userIds: [String], completion: @escaping ([Bandyer.UserDetails]) -> Void) {
        completion(detailsFor(userIds: userIds))
    }

    func provideHandle(_ userIds: [String], completion: @escaping (CXHandle) -> Void) {
        completion(handleFor(userIds: userIds))
    }

    private func detailsFor(userIds: [String]) -> [Bandyer.UserDetails] {
        userIds.map { id in
            cache.item(forKey: id) ?? .init(userID: id)
        }
    }

    private func handleFor(userIds: [String]) -> CXHandle {
        guard !userIds.isEmpty else { return .init(type: .generic, value: "") }
        let details = detailsFor(userIds: userIds)
        return .init(type: .generic, value: formatter.string(for: details) ?? userIds.joined(separator: ", ") )
    }
}
