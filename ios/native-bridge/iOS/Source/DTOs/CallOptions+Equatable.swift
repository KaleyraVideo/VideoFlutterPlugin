// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
extension CallOptions: Equatable {

    static func == (lhs: CallOptions, rhs: CallOptions) -> Bool {
        lhs.recordingType == rhs.recordingType
    }
}
