// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

protocol JSONDecodingTestCase: JSONDecodingTrait {
    associatedtype SUT where SUT: Decodable

    func decode(_ json: String) throws -> SUT
}

extension JSONDecodingTestCase {

    func decode(_ json: String) throws -> SUT {
        try decode(SUT.self, json: json)
    }
}

protocol JSONDecodingTrait {

    func decode<T: Decodable>(_ type: T.Type, json: String) throws -> T

    func decode<T: Decodable>(_ type: T.Type, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, json: String) throws -> T

    func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder, json: String) throws -> T
}

extension JSONDecodingTrait {

    func decode<T: Decodable>(_ type: T.Type, json: String) throws -> T {
        try decode(type, decoder: JSONDecoder(), json: json)
    }

    func decode<T: Decodable>(_ type: T.Type, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, json: String) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return try decode(type, decoder: decoder, json: json)
    }

    func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder, json: String) throws -> T {
        try decoder.decode(type, from: Data(json.utf8))
    }
}
