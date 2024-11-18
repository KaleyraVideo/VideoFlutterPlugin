// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

protocol KaleyraVideoSDKProtocol: AnyObject {

    var config: KaleyraVideoSDK.Config? { get }
    var userDetailsProvider: KaleyraVideoSDK.UserDetailsProvider? { get set }
    var conversation: KaleyraVideoSDK.Conversation? { get }
    var conference: KaleyraVideoSDK.Conference? { get }

    func configure(_ config: KaleyraVideoSDK.Config) throws
    func connect(userId: String, provider: AccessTokenProvider) throws
    func disconnect()
    func reset()
}

extension KaleyraVideo: KaleyraVideoSDKProtocol {}
