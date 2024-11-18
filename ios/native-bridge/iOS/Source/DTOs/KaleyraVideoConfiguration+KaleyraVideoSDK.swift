// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import UIKit
import KaleyraVideoSDK
import PushKit

extension KaleyraVideoConfiguration {

    private enum ConfigurationError: Error {
        case unsupportedEnvironment
        case unsupportedRegion
    }

    var isCallkitEnabled: Bool {
        iosConfig?.callkit?.enabled ?? true
    }

    var voipStrategy: VoipHandlingStrategy {
        iosConfig?.voipHandlingStrategy ?? .automatic
    }

    func makeKaleyraVideoSDKConfig() throws -> KaleyraVideoSDK.Config {
        guard let kaleyraEnv = environment.kaleyraEnvironment else {
            throw ConfigurationError.unsupportedEnvironment
        }

        guard let kaleyraRegion = region.kaleyraRegion else {
            throw ConfigurationError.unsupportedRegion
        }

        var config = KaleyraVideoSDK.Config(appID: appID, region: kaleyraRegion, environment: kaleyraEnv)
        config.callKit = iosConfig?.makeCallKitConfiguration() ?? .enabled(.default)
        config.voip = iosConfig?.makeVoIPConfiguration() ?? .manual
        return config
    }

    func makeToolsConfig() -> KaleyraVideoSDK.ConferenceSettings.Tools {
        var config = KaleyraVideoSDK.ConferenceSettings.Tools.default
        config.chat = tools?.makeChatConfiguration() ?? .disabled
        config.broadcastScreenSharing = tools?.makeBroadcastScreenSharingConfiguration() ?? .disabled
        config.inAppScreenSharing = tools?.makeInAppScreenSharingConfiguration() ?? .disabled
        config.fileshare = tools?.makeFileShareConfiguration() ?? .disabled
        config.whiteboard = tools?.makeWhiteboardConfiguration() ?? .disabled
        return config
    }
}

private extension IosConfiguration {

    func makeCallKitConfiguration() -> KaleyraVideoSDK.Config.CallKitIntegration {

        guard let callkitConfig = callkit else {
            return .enabled(.default)
        }

        if callkitConfig.enabled ?? true {
            let image: UIImage? = if let iconName = callkitConfig.appIconName {
                UIImage(named: iconName)
            } else {
                nil
            }
            return .enabled(.init(icon: image, ringtoneSound: callkitConfig.ringtoneSoundName))
        } else {
            return .disabled
        }
    }

    func makeVoIPConfiguration() -> KaleyraVideoSDK.Config.VoIP {
        if voipHandlingStrategy == nil || voipHandlingStrategy == .automatic {
            return .automatic(listenForNotificationsInForeground: false)
        } else {
            return .manual
        }
    }
}

private extension Tools {

    func makeChatConfiguration() -> KaleyraVideoSDK.ConferenceSettings.Tools.Chat {
        guard chat != nil else { return .disabled }
        return .enabled
    }

    func makeBroadcastScreenSharingConfiguration() -> KaleyraVideoSDK.ConferenceSettings.Tools.BroadcastScreenSharing {
        guard let screenShare, 
                screenShare.wholeDevice ?? false,
                let configURL = Bundle.main.url(forResource: "KaleyraVideoConfig", withExtension: "plist") else { return .disabled }

        let reader = BroadcastConfigurationPlistReader()
        guard let broadcastConfig = try? reader.read(fileURL: configURL),
                let appGroupIdentifier = try? AppGroupIdentifier(broadcastConfig.appGroupID) else { return .disabled }

        return .enabled(appGroupIdentifier: appGroupIdentifier, extensionBundleIdentifier: broadcastConfig.extensionBundleID)

    }

    func makeInAppScreenSharingConfiguration() -> KaleyraVideoSDK.ConferenceSettings.Tools.InAppScreenSharing {
        guard let screenShare, screenShare.inApp ?? false else { return .disabled }
        return .enabled
    }

    func makeFileShareConfiguration() -> KaleyraVideoSDK.ConferenceSettings.Tools.Fileshare {
        guard fileShare ?? false else { return .disabled }
        return .enabled
    }

    func makeWhiteboardConfiguration() -> KaleyraVideoSDK.ConferenceSettings.Tools.Whiteboard {
        guard whiteboard ?? false else { return .disabled }
        return .enabled
    }
}
