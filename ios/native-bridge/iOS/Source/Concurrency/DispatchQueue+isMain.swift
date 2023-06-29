// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Dispatch

@available(iOS 12.0, *)
public extension DispatchQueue {

    private static var mainSpecificKey: DispatchSpecificKey<Void> = {
        let key = DispatchSpecificKey<Void>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        return key
    }()

    static var isMain: Bool {
        DispatchQueue.getSpecific(key: mainSpecificKey) != nil
    }
}
