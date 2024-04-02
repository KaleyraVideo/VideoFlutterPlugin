// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import PushKit
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class KaleyraVideoConfiguration_BandyerTests: UnitTestCase {

    func testBandyerPluginConfigurationDefaultIsCallkitEnabled() {
        let sut = makeBandyerPluginConfiguration()

        assertThat(sut.isCallkitEnabled, isTrue())
    }

    func testBandyerPluginConfigurationIsCallkitEnabled() {
        let disabled = makeBandyerPluginConfiguration(callkit: CallKitConfiguration(appIconName: nil, enabled: false, ringtoneSoundName: nil))
        let enabled = makeBandyerPluginConfiguration(callkit: CallKitConfiguration(appIconName: nil, enabled: true, ringtoneSoundName: nil))

        assertThat(disabled.isCallkitEnabled, isFalse())
        assertThat(enabled.isCallkitEnabled, isTrue())
    }

    func testBandyerPluginConfigurationDefaultVoipStrategy() {
        let sut = makeBandyerPluginConfiguration()

        assertThat(sut.voipStrategy, equalTo(.automatic))
    }

    func testBandyerPluginConfigurationVoipStrategy() {
        let automatic = makeBandyerPluginConfiguration(voipHandlingStrategy: .automatic)
        let disabled = makeBandyerPluginConfiguration(voipHandlingStrategy: .disabled)

        assertThat(automatic.voipStrategy, equalTo(.automatic))
        assertThat(disabled.voipStrategy, equalTo(.disabled))
    }

    func testIosConfigurationMakeVoipConfigurationBuilderShouldBeAutomaticByDefault() throws {
        let delegate = makeDummyPushRegistryDelegate()
        let conf = makeBandyerPluginConfiguration()

        let bandyerConf = try conf.makeBandyerConfig(registryDelegate: delegate)

        assertThat(bandyerConf.voip.automaticallyHandleVoIPNotifications, isTrue())
        assertThat(bandyerConf.voip.pushRegistryDelegate, presentAnd(instanceOfAnd(equalTo(delegate))))
    }

    func testIosConfigurationMakeVoipConfigurationBuilderWithDisabledStrategy() throws {
        let delegate = makeDummyPushRegistryDelegate()
        let conf = makeBandyerPluginConfiguration(voipHandlingStrategy: .disabled)

        let bandyerConf = try conf.makeBandyerConfig(registryDelegate: delegate)

        assertThat(bandyerConf.voip.automaticallyHandleVoIPNotifications, isFalse())
        assertThat(bandyerConf.voip.pushRegistryDelegate, nilValue())
    }

    func testIosConfigurationMakeVoipConfigurationBuilderWithNilRegistryDelegate() throws {
        let conf = makeBandyerPluginConfiguration()

        let bandyerConf = try conf.makeBandyerConfig()

        assertThat(bandyerConf.voip.automaticallyHandleVoIPNotifications, isFalse())
        assertThat(bandyerConf.voip.pushRegistryDelegate, nilValue())
    }

    func testIosConfigurationMakeVoipConfigurationBuilderWithAutomaticStrategyAndRegistryDelegate() throws {
        let delegate = makeDummyPushRegistryDelegate()
        let conf = makeBandyerPluginConfiguration(voipHandlingStrategy: .automatic)

        let bandyerConf = try conf.makeBandyerConfig(registryDelegate: delegate)

        assertThat(bandyerConf.voip.automaticallyHandleVoIPNotifications, isTrue())
        assertThat(bandyerConf.voip.pushRegistryDelegate, presentAnd(instanceOfAnd(equalTo(delegate))))
    }

    // MARK: - Tools

    func testChatToolConfiguration() throws {
        let noChatConf = makeBandyerPluginConfiguration(tools: makeTools(isChatEnabled: false))
        let chatConf = makeBandyerPluginConfiguration(tools: makeTools(isChatEnabled: true))

        let bandyerNoChatConf = try noChatConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerChatConf = try chatConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())

        assertThat(bandyerNoChatConf.tools.chat.isEnabled, isFalse())
        assertThat(bandyerChatConf.tools.chat.isEnabled, isTrue())
    }

    func testFileShareToolConfiguration() throws {
        let fileshareDisabledConf = makeBandyerPluginConfiguration(tools: makeTools(isFileShareEnabled: false))
        let fileshareNilConf = makeBandyerPluginConfiguration(tools: makeTools(isFileShareEnabled: nil))
        let fileshareEnabledConf = makeBandyerPluginConfiguration(tools: makeTools(isFileShareEnabled: true))

        let bandyerFileshareDisabledConf = try fileshareDisabledConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerFileshareNilConf = try fileshareNilConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerFileshareEnalbedConf = try fileshareEnabledConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())

        assertThat(bandyerFileshareDisabledConf.tools.fileshare.isEnabled, isFalse())
        assertThat(bandyerFileshareNilConf.tools.fileshare.isEnabled, isFalse())
        assertThat(bandyerFileshareEnalbedConf.tools.fileshare.isEnabled, isTrue())
    }

    func testWhiteboardToolConfiguration() throws {
        let whiteboardDisabledConf = makeBandyerPluginConfiguration(tools: makeTools(isWhiteboardEnabled: false))
        let whiteboardNilConf = makeBandyerPluginConfiguration(tools: makeTools(isWhiteboardEnabled: nil))
        let whiteboardEnabledConf = makeBandyerPluginConfiguration(tools: makeTools(isWhiteboardEnabled: true))

        let bandyerWhiteboardDisabledConf = try whiteboardDisabledConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerWhiteboardNilConf = try whiteboardNilConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerWiteboardEnabledConf = try whiteboardEnabledConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())

        assertThat(bandyerWhiteboardDisabledConf.tools.whiteboard.isEnabled, isFalse())
        assertThat(bandyerWhiteboardNilConf.tools.whiteboard.isEnabled, isFalse())
        assertThat(bandyerWiteboardEnabledConf.tools.whiteboard.isEnabled, isTrue())
        assertThat(bandyerWiteboardEnabledConf.tools.whiteboard.isEnabled, isTrue())
    }

    func testScreenShareConfiguration() throws {
        let disabledScreenShareConf = makeBandyerPluginConfiguration(tools: makeTools(screenShareConf: .disabled))
        let disabledInAppAndDeviceScreenShareConf = makeBandyerPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: false, wholeDevice: false)))
        let nilInAppAndDeviceScreenShareConf = makeBandyerPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: nil, wholeDevice: nil)))
        let enabledInAppAndDisabledDeviceScreenShareConf = makeBandyerPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: true, wholeDevice: false)))
        let disabledInAppAndEnabledDeviceScreenShareConf = makeBandyerPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: false, wholeDevice: true)))
        let enabledAllScreenShareConf = makeBandyerPluginConfiguration(tools: makeTools(screenShareConf: .enabled(inApp: true, wholeDevice: true)))

        let bandyerDisabledScreenShareConf = try disabledScreenShareConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerDisabledInAppAndDeviceScreenShareConf = try disabledInAppAndDeviceScreenShareConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerNilInAppAndDeviceScreenShareConf = try nilInAppAndDeviceScreenShareConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerEnabledInAppAndDisabledDeviceScreenShareConf = try enabledInAppAndDisabledDeviceScreenShareConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerDisabledInAppAndEnabledDeviceScreenShareConf = try disabledInAppAndEnabledDeviceScreenShareConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())
        let bandyerEnabledAllScreenShareConf = try enabledAllScreenShareConf.makeBandyerConfig(registryDelegate: makeDummyPushRegistryDelegate())

        assertThat(bandyerDisabledScreenShareConf.tools.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledScreenShareConf.tools.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledInAppAndDeviceScreenShareConf.tools.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledInAppAndDeviceScreenShareConf.tools.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerNilInAppAndDeviceScreenShareConf.tools.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerNilInAppAndDeviceScreenShareConf.tools.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerEnabledInAppAndDisabledDeviceScreenShareConf.tools.inAppScreenSharing.isEnabled, isTrue())
        assertThat(bandyerEnabledInAppAndDisabledDeviceScreenShareConf.tools.broadcastScreenSharing.isEnabled, isFalse())
        assertThat(bandyerDisabledInAppAndEnabledDeviceScreenShareConf.tools.inAppScreenSharing.isEnabled, isFalse())
        assertThat(bandyerEnabledAllScreenShareConf.tools.inAppScreenSharing.isEnabled, isTrue())
    }

    // MARK: - Helpers

    private func makeBandyerPluginConfiguration(callkit: CallKitConfiguration? = nil,
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

    private func makeDummyPushRegistryDelegate() -> DummyPushRegistryDelegate {
        .init()
    }

    // MARK: - Doubles

    fileprivate enum ScreenShare {

        case disabled
        case enabled(inApp: Bool?, wholeDevice: Bool?)
    }

    class DummyPushRegistryDelegate: NSObject, PKPushRegistryDelegate {

        func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {}
    }
}

private extension KaleyraVideoConfiguration_BandyerTests.ScreenShare {

    func toScreenShareConfiguration() -> ScreenShareToolConfiguration? {
        switch self {
            case .disabled:
                return nil
            case .enabled(let inApp, let wholeDevice):
                return .init(inApp: inApp, wholeDevice: wholeDevice)
        }
    }
}
