// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
extension URL {

    static func fromString(_ string: String) throws -> URL {
        guard let url = URL(string: string.unescape()) else {
            throw VideoHybridNativeBridgeError.unableToInitializeURLError(urlString: string)
        }
        return url
    }
}

@available(iOS 12.0, *)
private extension String {

    func unescape() -> String {
        guard let unescaped = try? JSONDecoder().decode(String.self, from: self.data(using: .utf8)!) else {
            return self
        }
        return unescaped
    }
}
