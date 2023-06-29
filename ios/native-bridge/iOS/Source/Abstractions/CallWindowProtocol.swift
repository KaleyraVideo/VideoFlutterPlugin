// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
protocol CallWindowProtocol: AnyObject {

    var isHidden: Bool { get set }
    var callDelegate: Bandyer.CallWindowDelegate? { get set }

    func setConfiguration(_ configuration: Bandyer.CallViewControllerConfiguration?)
    func presentCallViewController(for intent: Bandyer.Intent, completion: ((Error?) -> Void)?)
}

@available(iOS 12.0, *)
extension CallWindow: CallWindowProtocol {}
