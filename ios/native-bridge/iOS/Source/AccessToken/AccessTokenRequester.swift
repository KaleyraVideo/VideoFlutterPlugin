// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
protocol AccessTokenRequester {
    func requestAccessToken(request: AccessTokenRequest) throws
}
