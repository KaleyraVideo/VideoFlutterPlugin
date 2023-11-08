// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
protocol BandyerSDKProtocol: AnyObject {

    var config: Bandyer.Config? { get }
    var userDetailsProvider: Bandyer.UserDetailsProvider? { get set }
    var callClient: Bandyer.CallClient! { get }
    var chatClient: Bandyer.ChatClient! { get }
    var notificationsCoordinator: Bandyer.InAppNotificationsCoordinator? { get }
    var callRegistry: Bandyer.CallRegistry! { get }

    func configure(_ config: Bandyer.Config)
    func connect(_ session: Bandyer.Session)
    func verifiedUser(_ verified: Bool, for call: Bandyer.Call, completion: ((Error?) -> Void)?)
    func disconnect()
    func reset()
}

@available(iOS 12.0, *)
extension BandyerSDK: BandyerSDKProtocol {}
