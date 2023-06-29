// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

protocol JSONDecodable {

    static func decodeJSON(_ json: String, encoding: String.Encoding) throws -> Self

    static func decodeJSON(data: Data) throws -> Self
}

extension JSONDecodable where Self: Decodable {

    static func decodeJSON(_ json: String, encoding: String.Encoding = .utf8) throws -> Self {
        guard let data = json.data(using: encoding) else {
            throw StringEncodingError()
        }
        return try decodeJSON(data: data)
    }

    static func decodeJSON(data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}

private struct StringEncodingError: Error {}
