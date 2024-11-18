// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension CallOptions: Equatable {

    static func == (lhs: CallOptions, rhs: CallOptions) -> Bool {
        lhs.recordingType == rhs.recordingType
    }
}
