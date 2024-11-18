// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

extension UserDetails {

    var bandyerDetails: KaleyraVideoSDK.UserDetails {
        .init(userId: userID, 
              name: name,
              image: URL(string: imageURL ?? ""),
              handle: .init(type: .generic, value: name ?? userID))
    }
}
