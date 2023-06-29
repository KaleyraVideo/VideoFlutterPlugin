// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
final class MainQueueRelay<Decoratee> {

    let decoratee: Decoratee

    init(_ decoratee: Decoratee) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        MainQueueDispatcher.perform(completion)
    }
}
