// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension AudioCallOptions: Equatable {

    static func == (lhs: AudioCallOptions, rhs: AudioCallOptions) -> Bool {
        lhs.callOptions == rhs.callOptions && lhs.recordingType == rhs.recordingType
    }
}
