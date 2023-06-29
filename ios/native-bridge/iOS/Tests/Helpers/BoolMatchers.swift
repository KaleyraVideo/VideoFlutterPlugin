// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest

func isTrue() -> Matcher<Bool> {
    return Matcher("true") { (value: Bool) in
        value == true
    }
}

func isFalse() -> Matcher<Bool> {
    return Matcher("false") { (value: Bool) in
        value != true
    }
}
