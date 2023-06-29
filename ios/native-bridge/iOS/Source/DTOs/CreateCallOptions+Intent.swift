// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
extension CreateCallOptions {

    func makeStartOutgoingCallIntent() -> StartOutgoingCallIntent {
        .init(callees: callees, options: makeCallOptions())
    }

    private func makeCallOptions() -> Bandyer.CallOptions {
        .init(callType: callType.bandyerType, recordingType: recordingType?.callRecordingType ?? CallRecordingType.none)
    }
}
