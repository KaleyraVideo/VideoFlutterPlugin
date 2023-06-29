// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
class FormatterProxy: Formatter {

    private static let defaultFormatter = UserDetailsFormatter(format: "${useralias}")

    private let lock: Lock = NSRecursiveLock()
    private var _formatter: Formatter

    var formatter: Formatter! {
        get {
            lock.sync {
                _formatter
            }
        }

        set {
            lock.sync {
                guard newValue != nil else {
                    _formatter = Self.defaultFormatter
                    return
                }

                _formatter = newValue
            }
        }
    }

    override init() {
        _formatter = Self.defaultFormatter
        super.init()
    }

    required init?(coder: NSCoder) {
        _formatter = Self.defaultFormatter
        super.init(coder: coder)
    }

    override func string(for obj: Any?) -> String? {
        formatter.string(for: obj)
    }

}
