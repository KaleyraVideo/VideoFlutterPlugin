// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import PushKit
@testable import KaleyraVideoHybridNativeBridge

final class KaleyraVideoConfiguration_KaleyraVideoSDKTests: UnitTestCase {

    func testBandyerPluginConfigurationDefaultIsCallkitEnabled() {
        let sut = makeKaleyraVideoPluginConfiguration()

        assertThat(sut.isCallkitEnabled, isTrue())
    }

    func testBandyerPluginConfigurationIsCallkitEnabled() {
        let disabled = makeKaleyraVideoPluginConfiguration(callkit: CallKitConfiguration(appIconName: nil, enabled: false, ringtoneSoundName: nil))
        let enabled = makeKaleyraVideoPluginConfiguration(callkit: CallKitConfiguration(appIconName: nil, enabled: true, ringtoneSoundName: nil))

        assertThat(disabled.isCallkitEnabled, isFalse())
        assertThat(enabled.isCallkitEnabled, isTrue())
    }

    func testBandyerPluginConfigurationDefaultVoipStrategy() {
        let sut = makeKaleyraVideoPluginConfiguration()

        assertThat(sut.voipStrategy, equalTo(.automatic))
    }

    func testBandyerPluginConfigurationVoipStrategy() {
        let automatic = makeKaleyraVideoPluginConfiguration(voipHandlingStrategy: .automatic)
        let disabled = makeKaleyraVideoPluginConfiguration(voipHandlingStrategy: .disabled)

        assertThat(automatic.voipStrategy, equalTo(.automatic))
        assertThat(disabled.voipStrategy, equalTo(.disabled))
    }

    func testIosConfigurationMakeVoipConfigurationShouldBeAutomaticByDefault() throws {
        let conf = makeKaleyraVideoPluginConfiguration()

        let bandyerConf = try conf.makeKaleyraVideoSDKConfig()

        assertThat(bandyerConf.voip.isAutomatic, isTrue())
    }

    func testIosConfigurationMakeVoipConfigurationWithDisabledStrategy() throws {
        let conf = makeKaleyraVideoPluginConfiguration(voipHandlingStrategy: .disabled)

        let bandyerConf = try conf.makeKaleyraVideoSDKConfig()

        assertThat(bandyerConf.voip.isAutomatic, isFalse())
    }

    func testIosConfigurationMakeVoipConfigurationWithAutomaticStrategyAndRegistryDelegate() throws {
        let conf = makeKaleyraVideoPluginConfiguration(voipHandlingStrategy: .automatic)

        let bandyerConf = try conf.makeKaleyraVideoSDKConfig()

        assertThat(bandyerConf.voip.isAutomatic, isTrue())
    }

    // MARK: - Tools

    func testChatToolConfiguration() {
        let noChatConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isChatEnabled: false))
        let chatConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isChatEnabled: true))

        let bandyerNoChatConf = noChatConf.makeToolsConfig()
        let bandyerChatConf = chatConf.makeToolsConfig()

        assertThat(bandyerNoChatConf.chat.isEnabled, isFalse())
        assertThat(bandyerChatConf.chat.isEnabled, isTrue())
    }

    func testFileShareToolConfiguration() {
        let fileshareDisabledConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isFileShareEnabled: false))
        let fileshareNilConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isFileShareEnabled: nil))
        let fileshareEnabledConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isFileShareEnabled: true))

        let bandyerFileshareDisabledConf = fileshareDisabledConf.makeToolsConfig()
        let bandyerFileshareNilConf = fileshareNilConf.makeToolsConfig()
        let bandyerFileshareEnalbedConf = fileshareEnabledConf.makeToolsConfig()

        assertThat(bandyerFileshareDisabledConf.fileshare.isEnabled, isFalse())
        assertThat(bandyerFileshareNilConf.fileshare.isEnabled, isFalse())
        assertThat(bandyerFileshareEnalbedConf.fileshare.isEnabled, isTrue())
    }

    func testWhiteboardToolConfiguration() {
        let whiteboardDisabledConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isWhiteboardEnabled: false))
        let whiteboardNilConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isWhiteboardEnabled: nil))
        let whiteboardEnabledConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(isWhiteboardEnabled: true))

        let bandyerWhiteboardDisabledConf = whiteboardDisabledConf.makeToolsConfig()
        let bandyerWhiteboardNilConf = whiteboardNilConf.makeToolsConfig()
        let bandyerWiteboardEnabledConf = whiteboardEnabledConf.makeToolsConfig()

        assertThat(bandyerWhiteboardDisabledConf.whiteboard.isEnabled, isFalse())
        assertThat(bandyerWhiteboardNilConf.whiteboard.isEnabled, isFalse())
        assertThat(bandyerWiteboardEnabledConf.whiteboard.isEnabled, isTrue())
        assertThat(bandyerWiteboardEnabledConf.whiteboard.isEnabled, isTrue())
    }

    func testScreenShareConfiguration() {
        let disabledScreenShareConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(screenShareConf: .disabled))
        let disabledInAppAndDeviceScreenShareConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: false, wholeDevice: false)))
        let nilInAppAndDeviceScreenShareConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: nil, wholeDevice: nil)))
        let enabledInAppAndDisabledDeviceScreenShareConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: true, wholeDevice: false)))
        let disabledInAppAndEnabledDeviceScreenShareConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: false, wholeDevice: true)))
        let enabledAllScreenShareConf = makeKaleyraVideoPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: true, wholeDevice: true)))

        let bandyerDisabledScreenShareConf = disabledScreenShareConf.makeToolsConfig()
        let bandyerDisabledInAppAndDeviceScreenShareConf = disabledInAppAndDeviceScreenShareConf.makeToolsConfig()
        let bandyerNilInAppAndDeviceScreenShareConf = nilInAppAndDeviceScreenShareConf.makeToolsConfig()
        let bandyerEnabledInAppAndDisabledDeviceScreenShareConf = enabledInAppAndDisabledDeviceScreenShareConf.makeToolsConfig()
        let bandyerDisabledInAppAndEnabledDeviceScreenShareConf = disabledInAppAndEnabledDeviceScreenShareConf.makeToolsConfig()
        let bandyerEnabledAllScreenShareConf = enabledAllScreenShareConf.makeToolsConfig()

        assertThat(bandyerDisabledScreenShareConf.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledScreenShareConf.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledInAppAndDeviceScreenShareConf.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledInAppAndDeviceScreenShareConf.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerNilInAppAndDeviceScreenShareConf.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerNilInAppAndDeviceScreenShareConf.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerEnabledInAppAndDisabledDeviceScreenShareConf.inAppScreenSharing.isEnabled, isTrue())
        assertThat(bandyerEnabledInAppAndDisabledDeviceScreenShareConf.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledInAppAndEnabledDeviceScreenShareConf.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerEnabledAllScreenShareConf.inAppScreenSharing.isEnabled, isTrue())
    }

    // MARK: - Helpers

    private func makeKaleyraVideoPluginConfiguration(callkit: CallKitConfiguration? = nil,
                                                     voipHandlingStrategy: VoipHandlingStrategy? = nil,
                                                     tools: Tools? = nil) -> KaleyraVideoConfiguration {
        .init(appID: "",
              environment: Environment(name: "sandbox"),
              iosConfig: IosConfiguration(callkit: callkit,
                                          voipHandlingStrategy: voipHandlingStrategy),
              logEnabled: false,
              region: Region(name: "europe"),
              tools: tools)
    }

    private func makeTools(isChatEnabled: Bool = false,
                           isFileShareEnabled: Bool? = nil,
                           screenShareConf: ScreenShare = .disabled,
                           isWhiteboardEnabled: Bool? = nil) -> Tools {
        .init(chat: isChatEnabled ? .init(audioCallOption: .init(recordingType: nil, type: .audio),
                                          videoCallOption: .init(recordingType: nil)) : nil,
              feedback: nil,
              fileShare: isFileShareEnabled,
              screenShare: screenShareConf.toScreenShareConfiguration(),
              whiteboard: isWhiteboardEnabled)
    }

    // MARK: - Doubles

    fileprivate enum ScreenShare {

        case disabled
        case enabled(inApp: Bool?, wholeDevice: Bool?)
    }
}

private extension KaleyraVideoConfiguration_KaleyraVideoSDKTests.ScreenShare {

    func toScreenShareConfiguration() -> ScreenShareToolConfiguration? {
        switch self {
            case .disabled:
                return nil
            case .enabled(let inApp, let wholeDevice):
                return .init(inApp: inApp, wholeDevice: wholeDevice)
        }
    }
}
