// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import PushKit

class FakePushCredentials: PKPushCredentials {

    private let data: Data

    override var type: PKPushType { .voIP }
    override var token: Data { data }

    init(data: Data) {
        self.data = data
        super.init()
    }
}
