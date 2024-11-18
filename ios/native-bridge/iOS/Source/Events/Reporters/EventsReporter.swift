// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

protocol SDKEventReporter {

    var lastVoIPToken: String? { get }

    func start()
    func stop()
}

class EventsReporter: SDKEventReporter {

    // MARK: - Properties

    private let emitter: EventEmitter
    private let sdk: KaleyraVideoSDKProtocol

    private(set) var callClientEventReporter: CallClientEventsReporter?
    private(set) var chatClientEventReporter: ChatClientEventsReporter?

    var lastVoIPToken: String? {
        callClientEventReporter?.lastVoIPToken
    }

    // MARK: - Init

    init(emitter: EventEmitter, sdk: KaleyraVideoSDKProtocol) {
        self.emitter = emitter
        self.sdk = sdk
    }

    // MARK: - Start Reporting Events

    func start() {
        startReportingCallClientEvents(sdk.conference)
        startReportingChatClientEvents(sdk.conversation)
    }

    private func startReportingCallClientEvents(_ conference: Conference?) {
        guard let conference, callClientEventReporter == nil else { return }

        callClientEventReporter = .init(conference: conference, emitter: emitter)
        callClientEventReporter?.start()
    }

    private func startReportingChatClientEvents(_ conversation: Conversation?) {
        guard let conversation, chatClientEventReporter == nil else { return }

        chatClientEventReporter = .init(conversation: conversation, emitter: emitter)
        chatClientEventReporter?.start()
    }

    // MARK: - Stop Reporting Events

    func stop() {
        stopCallClientEventReporter()
        stopChatClientEventReporter()
    }

    private func stopCallClientEventReporter() {
        callClientEventReporter?.stop()
        callClientEventReporter = nil
    }

    private func stopChatClientEventReporter() {
        chatClientEventReporter?.stop()
        chatClientEventReporter = nil
    }
}
