// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
@testable import KaleyraVideoHybridNativeBridge

class UserInterfacePresenterSpy: UserInterfacePresenter {

    private(set) var configureInvocations = [UserInterfacePresenterConfiguration]()
    private(set) var presentCallWithOptionsInvocations = [CreateCallOptions]()
    private(set) var presentCallWithURLInvocations = [URL]()
    private(set) var presentChatInvocations = [String]()

    var onConfigure: (() -> Void)?
    var onPresentCallWithOptions: (() -> Void)?
    var onPresentCallWithURL: (() -> Void)?
    var onPresentChat: (() -> Void)?

    func configure(with configuration: UserInterfacePresenterConfiguration) {
        configureInvocations.append(configuration)
        onConfigure?()
    }

    func presentCall(_ options: CreateCallOptions) {
        presentCallWithOptionsInvocations.append(options)
        onPresentCallWithOptions?()
    }

    func presentCall(_ url: URL) {
        presentCallWithURLInvocations.append(url)
        onPresentCallWithURL?()
    }

    func presentChat(with userID: String) {
        presentChatInvocations.append(userID)
        onPresentChat?()
    }
}
