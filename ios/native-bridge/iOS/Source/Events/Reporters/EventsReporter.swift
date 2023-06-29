// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
protocol SDKEventReporter {

    func start()
    func stop()
}

@available(iOS 12.0, *)
class EventsReporter: SDKEventReporter {

    // MARK: - Properties

    private let emitter: EventEmitter
    private let sdk: BandyerSDKProtocol

    private(set) var callClientEventReporter: CallClientEventsReporter?
    private(set) var chatClientEventReporter: ChatClientEventsReporter?

    // MARK: - Init

    init(emitter: EventEmitter, sdk: BandyerSDKProtocol) {
        self.emitter = emitter
        self.sdk = sdk
    }

    // MARK: - Start Reporting Events

    func start() {
        startReportingCallClientEvents(sdk.callClient)
        startReportingChatClientEvents(sdk.chatClient)
    }

    private func startReportingCallClientEvents(_ callClient: CallClient) {
        guard callClientEventReporter == nil else { return }

        callClientEventReporter = .init(client: callClient, emitter: emitter)
        callClientEventReporter?.start()
    }

    private func startReportingChatClientEvents(_ chatClient: ChatClient) {
        guard chatClientEventReporter == nil else { return }

        chatClientEventReporter = .init(client: chatClient, emitter: emitter)
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
