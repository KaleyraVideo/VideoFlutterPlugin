// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
protocol UserDetailsFixtureFactory {

    func makeItem(userID: String, firstname: String?, lastname: String?, email: String?, nickname: String?) -> Bandyer.UserDetails
}

@available(iOS 12.0, *)
extension UserDetailsFixtureFactory {

    func makeItem(userID: String, firstname: String? = nil, lastname: String? = nil, email: String? = nil, nickname: String? = nil) -> Bandyer.UserDetails {
        .init(userID: userID, firstname: firstname, lastname: lastname, email: email, nickname: nickname, imageURL: nil)
    }
}
