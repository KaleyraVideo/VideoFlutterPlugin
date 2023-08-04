// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
extension MainQueueRelay: UserInterfacePresenter where Decoratee: UserInterfacePresenter {

    func configure(with configuration: UserInterfacePresenterConfiguration) {
        decoratee.configure(with: configuration)
    }

    func presentCall(_ options: CreateCallOptions) {
        dispatch { [weak self] in
            self?.decoratee.presentCall(options)
        }
    }

    func presentCall(_ url: URL) {
        dispatch { [weak self] in
            self?.decoratee.presentCall(url)
        }
    }

    func presentChat(with userID: String) {
        dispatch { [weak self] in
            self?.decoratee.presentChat(with: userID)
        }
    }
}
