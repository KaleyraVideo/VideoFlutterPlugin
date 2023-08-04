// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import PushKit

@available(iOS 12.0, *)
class PushTokenEventsReporter: NSObject, PKPushRegistryDelegate {

    private let emitter: EventEmitter
    private(set) var lastToken: String?

    init(emitter: EventEmitter) {
        self.emitter = emitter
        super.init()
    }

    // MARK: - Push registry delegate

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let token = credentials.tokenAsString

        guard !token.isEmpty else { return }

        emitter.sendEvent(Events.iOSVoipPushTokenUpdated, args: token)

        lastToken = token
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        emitter.sendEvent(Events.iOSVoipPushTokenInvalidated, args: nil)
        lastToken = nil
    }
}
