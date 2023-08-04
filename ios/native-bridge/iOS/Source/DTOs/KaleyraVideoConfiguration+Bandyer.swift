// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import UIKit
import Bandyer
import PushKit

@available(iOS 12.0, *)
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

    func makeBandyerConfig(registryDelegate: PKPushRegistryDelegate? = nil) throws -> Bandyer.Config {
        guard let bandyerEnv = environment.bandyerEnvironment else {
            throw ConfigurationError.unsupportedEnvironment
        }

        guard let bandyerRegion = region.bandyerRegion else {
            throw ConfigurationError.unsupportedRegion
        }

        return try ConfigBuilder(appID: appID, environment: bandyerEnv, region: bandyerRegion)
            .callKit(iosConfig.makeCallkitConfigurationBuilder())
            .tools(tools.makeToolsConfigurationBuilder())
            .voip(iosConfig.makeVoipConfigurationBuilder(registryDelegate: registryDelegate))
            .build()
    }
}

@available(iOS 12.0, *)
private extension Optional where Wrapped == IosConfiguration {

    func makeCallkitConfigurationBuilder() -> CallKitConfigurationBuilder {
        switch self {
            case .none:
                let builder = CallKitConfigurationBuilder()
                builder.enabled()
                return builder
            case .some(let wrapped):
                return wrapped.makeCallkitConfigurationBuilder()
        }
    }

    func makeVoipConfigurationBuilder(registryDelegate: PKPushRegistryDelegate?) -> VoIPPushConfigurationBuilder {
        switch self {
            case .none:
                let builder = VoIPPushConfigurationBuilder()
                builder.manual()
                return builder
            case .some(let wrapped):
                return wrapped.makeVoipConfigurationBuilder(registryDelegate: registryDelegate)
        }
    }
}

@available(iOS 12.0, *)
private extension Optional where Wrapped == Tools {

    func makeToolsConfigurationBuilder() -> ToolsConfigurationBuilder {
        switch self {
            case .none:
                return ToolsConfigurationBuilder()
            case .some(let wrapped):
                return wrapped.makeToolsConfigurationBuilder()
        }
    }
}

@available(iOS 12.0, *)
private extension IosConfiguration {

    func makeCallkitConfigurationBuilder() -> CallKitConfigurationBuilder {
        let builder = CallKitConfigurationBuilder()

        guard let callkitConfig = callkit else {
            builder.enabled()
            return builder
        }

        if callkitConfig.enabled ?? true {
            builder.enabled { providerConf in
                if let iconName = callkitConfig.appIconName,
                   let image = UIImage(named: iconName) {
                    providerConf.icon(image)
                }
                if let ringtone = callkitConfig.ringtoneSoundName {
                    providerConf.ringtoneSound(ringtone)
                }
            }
        } else {
            builder.disabled()
        }
        return builder
    }

    func makeVoipConfigurationBuilder(registryDelegate: PKPushRegistryDelegate?) -> VoIPPushConfigurationBuilder {
        let builder = VoIPPushConfigurationBuilder()

        if (voipHandlingStrategy == nil || voipHandlingStrategy == .automatic),
            let delegate = registryDelegate {
            builder.automatic(pushRegistryDelegate: delegate)
        } else {
            builder.manual()
        }

        return builder
    }
}

@available(iOS 12.0, *)
private extension Tools {

    func makeToolsConfigurationBuilder() -> ToolsConfigurationBuilder {
        let builder = ToolsConfigurationBuilder()

        if chat != nil {
            builder.chat()
        }

        if fileShare != nil {
            builder.fileshare()
        }

        if whiteboard != nil {
            builder.whiteboard(uploadEnabled: true)
        }

        if let screenshare = screenShare {
            if screenshare.inApp ?? false {
                builder.inAppScreenSharing()
            }

            if screenshare.wholeDevice ?? false {
                if let configURL = Bundle.main.url(forResource: "KaleyraVideoConfig", withExtension: "plist") {
                    let reader = BroadcastConfigurationPlistReader()
                    if let broadcastConfig = try? reader.read(fileURL: configURL) {
                        builder.broadcastScreenSharing(appGroupIdentifier: broadcastConfig.appGroupID,
                                                       broadcastExtensionBundleIdentifier: broadcastConfig.extensionBundleID)
                    }
                }
            }
        }

        return builder
    }
}
