// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

struct Weak<Object: AnyObject> {

    private(set) var object: Object?

    init(_ object: Object) {
        self.object = object
    }
}
