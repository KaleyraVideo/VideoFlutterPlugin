// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
extension AudioCallOptions {

    var callOptions: Bandyer.CallOptions {
        .init(callType: type.callType,
              recordingType: recordingType.callRecordingType)
    }
}
