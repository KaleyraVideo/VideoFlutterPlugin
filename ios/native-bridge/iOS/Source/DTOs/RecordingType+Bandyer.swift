// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
extension RecordingType {

    var callRecordingType: Bandyer.CallRecordingType {
        switch self {
            case .automatic:
                return .automatic
            case .manual:
                return .manual
            case .none:
                return .none
        }
    }
}

@available(iOS 12.0, *)
extension Optional where Wrapped == RecordingType {

    var callRecordingType: Bandyer.CallRecordingType {
        switch self {
            case nil:
                return .none
            case .some(let wrapped):
                return wrapped.callRecordingType
        }
    }
}
