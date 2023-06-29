// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import XCTest

func unwrap<T>(_ expression: T?, file: StaticString = #filePath, line: UInt = #line) throws -> T {
    try XCTUnwrap(expression, file: file, line: line)
}
