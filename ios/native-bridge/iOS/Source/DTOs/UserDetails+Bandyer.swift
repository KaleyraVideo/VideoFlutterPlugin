// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
extension UserDetails {

    var bandyerDetails: Bandyer.UserDetails {
        .init(userID: userID,
              firstname: firstName,
              lastname: lastName,
              email: email,
              nickname: nickName,
              imageURL: URL(string: profileImageURL ?? ""))
    }
}
