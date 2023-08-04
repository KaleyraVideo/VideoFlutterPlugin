// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class UserDetailsFormatter: Formatter {

    let format: NSString
    private let tokensMap: [String : String]

    init(format: String) {
        self.format = format as NSString
        self.tokensMap = [
            "${useralias}" : "userID",
            "${userid}"    : "userID",
            "${firstname}" : "firstname",
            "${lastname}"  : "lastname",
            "${nickname}"  : "nickname",
            "${email}"     : "email"
        ]
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Formatting

    override func string(for obj: Any?) -> String? {
        if let items = obj as? [Bandyer.UserDetails] {
            return stringForItem(items)
        }

        if let item = obj as? Bandyer.UserDetails {
            return stringForItem(item)
        }

        return nil
    }

    private func stringForItem(_ items: [Bandyer.UserDetails]) -> String {
        items.map(stringForItem(_:)).joined(separator: ", ")
    }

    private func stringForItem(_ item: Bandyer.UserDetails) -> String {
        do {
            let tokens = try matchingTokensInFormat()
            let string = tokens.reduce(format) { result, token in
                guard let propertyName = tokensMap[token.lowercased()] else { return result }
                guard let propertyValue = item.value(forKey: propertyName) as? String else { return result.replacingOccurrences(of: token, with: "") as NSString }
                return result.replacingOccurrences(of: token, with: propertyValue) as NSString
            }

            let trimmed = string.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return item.userID }
            return trimmed
        } catch {
            return item.userID
        }
    }

    private func matchingTokensInFormat() throws -> [String] {
        let pattern = "\\$\\{([\\w]+)\\}"
        let regexp = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regexp.matches(in: format as String, range: .init(location: 0, length: format.length))

        return matches.compactMap { match in
            guard match.range.location != NSNotFound else { return nil }
            return format.substring(with: match.range)
        }
    }

    private func tokenReplacements(tokens: [String], item: Bandyer.UserDetails) -> [(String, String)] {
        tokens.map { token in
            guard let propertyName = tokensMap[token] else { return (token, "") }
            guard let propertyValue = item.value(forKey: propertyName) as? String else { return (token, "") }
            return (token, propertyValue)
        }
    }
}
