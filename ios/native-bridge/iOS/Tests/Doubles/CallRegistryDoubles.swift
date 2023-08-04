// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class CallRegistryMocked: NSObject, Bandyer.CallRegistry {

    private(set) var calls: [Bandyer.Call] = []

    var isBusy: Bool = false

    func call(with uuid: UUID) -> Bandyer.Call? {
        nil
    }

    func add(observer: Bandyer.CallRegistryObserver) {}

    func add(observer: Bandyer.CallRegistryObserver, queue: DispatchQueue?) {}

    func remove(observer: Bandyer.CallRegistryObserver) {}

    func addInProgressCall(_ call: Bandyer.Call) {
        calls.append(call)
    }
}

