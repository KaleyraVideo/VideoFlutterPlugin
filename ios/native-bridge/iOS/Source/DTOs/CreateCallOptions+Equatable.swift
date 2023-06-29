// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension CreateCallOptions: Equatable {

    static func == (lhs: CreateCallOptions, rhs: CreateCallOptions) -> Bool {
        lhs.callees == rhs.callees &&
        lhs.callType == rhs.callType &&
        lhs.recordingType == rhs.recordingType
    }
}
