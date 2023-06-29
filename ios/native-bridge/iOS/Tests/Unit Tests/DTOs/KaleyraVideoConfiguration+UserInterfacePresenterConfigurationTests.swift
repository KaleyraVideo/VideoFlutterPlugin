// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import Bandyer
@testable import KaleyraVideoHybridNativeBridge

@available(iOS 12.0, *)
final class KaleyraVideoConfiguration_UserInterfacePresenterConfigurationTests: UnitTestCase {

    func testUIPresenterConfiguration_ShowsFeedbackWhenCallEnds() {
        let sutWithFeedbackEnabled = makeSUT(feedback: true)
        let sutWithFeedbackDisabled = makeSUT(feedback: false)
        let sutWithFeedbackNil = makeSUT(feedback: nil)
        
        assertThat(sutWithFeedbackEnabled.uiPresenterConfiguration().showsFeedbackWhenCallEnds, isTrue())
        assertThat(sutWithFeedbackDisabled.uiPresenterConfiguration().showsFeedbackWhenCallEnds, isFalse())
        assertThat(sutWithFeedbackNil.uiPresenterConfiguration().showsFeedbackWhenCallEnds, isFalse())
    }

    func testUIPresenterConfiguration_ChatAudioButtonConf() {
        let audioOptions = makeAudioCallOptions()
        let sutWithAudioCallOptionEnabled = makeSUT(audioCallOption: audioOptions)
        let sutWithAudioCallOptionDisabled = makeSUT(audioCallOption: nil)

        assertThat(sutWithAudioCallOptionEnabled.uiPresenterConfiguration().chatAudioButtonConf, equalTo(.enabled(audioOptions)))
        assertThat(sutWithAudioCallOptionDisabled.uiPresenterConfiguration().chatAudioButtonConf, equalTo(.disabled))
    }

    func testUIPresenterConfiguration_ChatVideoButtonConf() {
        let videoOptions = makeCallOptions()
        let sutWithVideoCallOptionEnabled = makeSUT(videoCallOption: videoOptions)
        let sutWithVideoCallOptionDisabled = makeSUT(audioCallOption: nil)

        assertThat(sutWithVideoCallOptionEnabled.uiPresenterConfiguration().chatVideoButtonConf, equalTo(.enabled(videoOptions)))
        assertThat(sutWithVideoCallOptionDisabled.uiPresenterConfiguration().chatVideoButtonConf, equalTo(.disabled))
    }

    // MARK: - Helpers

    private func makeSUT(feedback: Bool? = nil,
                         audioCallOption: AudioCallOptions? = nil,
                         videoCallOption: KaleyraVideoHybridNativeBridge.CallOptions? = nil) -> KaleyraVideoConfiguration {
        .init(appID: "app_id",
              environment: .init(name: "sandbox"),
              iosConfig: .init(callkit: .init(appIconName: "app_icon",
                                              enabled: true,
                                              ringtoneSoundName: "ringtone"),
                               voipHandlingStrategy: .disabled),
              logEnabled: false,
              region: .init(name: "europe"),
              tools: .init(chat: .init(audioCallOption: audioCallOption, videoCallOption: videoCallOption),
                           feedback: feedback,
                           fileShare: false,
                           screenShare: .init(inApp: false,
                                              wholeDevice: false),
                           whiteboard: false))
    }

    private func makeAudioCallOptions() -> AudioCallOptions {
        .init(recordingType: .automatic, type: .audioUpgradable)
    }

    private func makeCallOptions() -> KaleyraVideoHybridNativeBridge.CallOptions {
        .init(recordingType: .manual)
    }
}

