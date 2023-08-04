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

    // MARK: - Helpers

    private func makeBandyerPluginConfiguration(callkit: CallKitConfiguration? = nil,
                                                voipHandlingStrategy: VoipHandlingStrategy? = nil) -> KaleyraVideoConfiguration {
        .init(appID: "",
              environment: Environment(name: "sandbox"),
              iosConfig: IosConfiguration(callkit: callkit,
                                          voipHandlingStrategy: voipHandlingStrategy),
              logEnabled: false,
              region: Region(name: "europe"),
              tools: nil)
    }

    private func makeDummyPushRegistryDelegate() -> DummyPushRegistryDelegate {
        .init()
    }
}

private class DummyPushRegistryDelegate: NSObject, PKPushRegistryDelegate {

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {}
}
