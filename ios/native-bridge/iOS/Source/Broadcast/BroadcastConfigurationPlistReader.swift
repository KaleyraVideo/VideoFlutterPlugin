// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@available(iOS 12.0, *)
struct BroadcastConfigurationPlistReader {

    struct BroadcastConfig {

        let appGroupID: String
        let extensionBundleID: String
    }

    enum ReaderError: Error {
        case urlIsNotAFile
        case notAPlistFile
        case appGroupIdentifierMissing
        case extensionBundleIdMissing
    }

    func read(fileURL url: URL) throws -> BroadcastConfig {
        guard url.isFileURL else {
            throw ReaderError.urlIsNotAFile
        }

        guard url.pathExtension == "plist" else {
            throw ReaderError.notAPlistFile
        }

        let values = try NSDictionary(contentsOf: url, error: ())
        let appGroupValue = values.value(forKeyPath: "broadcast.appGroupIdentifier")
        let extensionBundleIdValue = values.value(forKeyPath: "broadcast.extensionBundleIdentifier")

        guard let appGroupIdentifier = appGroupValue as? String,
                appGroupIdentifier != "",
                appGroupIdentifier != "NOT_AVAILABLE" else {
            throw ReaderError.appGroupIdentifierMissing
        }

        guard let extensionBundleId = extensionBundleIdValue as? String,
            extensionBundleId != "",
              extensionBundleId != "NOT_AVAILABLE" else {
            throw ReaderError.extensionBundleIdMissing
        }
        
        return .init(appGroupID: appGroupIdentifier, extensionBundleID: extensionBundleId)
    }
}
