// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

extension CreateCallOptions {

    func makeCallOptions() -> KaleyraVideoSDK.CallOptions {
        .init(type: callType.bandyerType, recording: recordingType?.callRecordingType)
    }
}
