// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
@testable import KaleyraVideoHybridNativeBridge

class EventEmitterSpy: EventEmitter {

    private(set) lazy var sentEvents = [(event: String, args: Any?)]()

    func sendEvent(_ event: Events, args: Any?) {
        sentEvents.append((event.description, args))
    }
}

class EventEmitterDummy: EventEmitter {

    func sendEvent(_ event: Events, args: Any?) {}
}
