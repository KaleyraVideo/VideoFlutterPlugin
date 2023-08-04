// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
class FormatterProxy: Formatter {

    @Atomic
    var formatter: Formatter?

    override func string(for obj: Any?) -> String? {
        formatter?.string(for: obj)
    }

}
