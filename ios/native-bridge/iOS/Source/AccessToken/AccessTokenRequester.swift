// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

protocol AccessTokenRequester {
    func requestAccessToken(request: AccessTokenRequest) throws
}
