// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension NSString {

    func tokenData() -> Data {
        let data = NSMutableData()
        var whole_byte: Int
        var byte_chars: [CChar] = [0, 0, 0]

        for i in 0..<(length / 2) {
            byte_chars[0] = CChar(character(at: i * 2))
            byte_chars[1] = CChar(character(at: i * 2 + 1))
            whole_byte = strtol(byte_chars, nil, 16)

            data.append(&whole_byte, length: 1)
        }

        return data as Data
    }
}
