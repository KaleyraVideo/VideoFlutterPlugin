// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

protocol CallWindowProtocol: AnyObject {

    var isHidden: Bool { get set }

    func makeKeyAndVisible()
    func set(rootViewController controller: UIViewController?, animated: Bool, completion: ((Bool) -> Void)?)
}

extension CallWindow: CallWindowProtocol {}
