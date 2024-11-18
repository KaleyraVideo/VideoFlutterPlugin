// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK
@testable import KaleyraVideoHybridNativeBridge

class KaleyraVideoSDKProtocolSpy: KaleyraVideoSDKProtocol {

    private(set) var config: KaleyraVideoSDK.Config?
    var userDetailsProvider: (any KaleyraVideoSDK.UserDetailsProvider)?

    let conversationStub = ConversationStub()
    var conversation: (any KaleyraVideoSDK.Conversation)? {
        conversationStub
    }

    let conferenceStub = ConferenceStub()
    var conference: (any KaleyraVideoSDK.Conference)? {
        conferenceStub
    }

    private(set) var configureInvocations = [KaleyraVideoSDK.Config]()
    private(set) var connectInvocations = [(userId: String, provider: any KaleyraVideoSDK.AccessTokenProvider)]()
    private(set) var disconnectInvocations: [Void] = []
    private(set) var resetInvocations: [Void] = []

    func configure(_ config: KaleyraVideoSDK.Config) throws {
        self.config = config
        configureInvocations.append(config)
        try KaleyraVideo.instance.configure(config)
    }
    
    func connect(userId: String, provider: any KaleyraVideoSDK.AccessTokenProvider) throws {
        connectInvocations.append((userId: userId, provider: provider))
    }
    
    func disconnect() {
        disconnectInvocations.append(())
    }
    
    func reset() {
        resetInvocations.append(())
    }

    deinit {
        KaleyraVideo.instance.reset()
    }
}

class KaleyraVideoSDKProtocolDummy: KaleyraVideoSDKProtocol {

    var config: KaleyraVideoSDK.Config?

    var userDetailsProvider: (any KaleyraVideoSDK.UserDetailsProvider)?

    var conversation: (any KaleyraVideoSDK.Conversation)? = ConversationStub()

    var conference: (any KaleyraVideoSDK.Conference)? = ConferenceStub()

    func configure(_ config: KaleyraVideoSDK.Config) throws {}

    func connect(userId: String, provider: any KaleyraVideoSDK.AccessTokenProvider) throws {}

    func disconnect() {}

    func reset() {}
}
