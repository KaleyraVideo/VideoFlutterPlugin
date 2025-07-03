// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

@objc(_KaleyraVideoHybridVersionInfo)
class _KaleyraVideoHybridVersionInfo: NSObject {

    @objc
    static let krvVersion: String = "2.3.1"

    @objc
    static let krvPlatform: String = "flutter"

    override var debugDescription: String {
        """
Plugin version info:
    Platform: \(_KaleyraVideoHybridVersionInfo.krvPlatform)
    Version: \(_KaleyraVideoHybridVersionInfo.krvVersion)
"""
    }

    func printDebugDescription() {
        debugPrint(debugDescription)
    }
}
