// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
protocol UserInterfacePresenter {

    func configure(with configuration: UserInterfacePresenterConfiguration)

    func presentCall(_ options: CreateCallOptions)
    func presentCall(_ url: URL)
    func presentChat(with userID: String)
}
