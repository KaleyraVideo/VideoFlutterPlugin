// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

extension KaleyraVideoConfiguration {

    func uiPresenterConfiguration() -> UserInterfacePresenterConfiguration {
        .init(showsFeedbackWhenCallEnds: tools?.feedback ?? false,
              chatAudioButtonConf: chatAudioButtonConf,
              chatVideoButtonConf: chatVideoButtonConf)
    }

    private var chatAudioButtonConf: UserInterfacePresenterConfiguration.ChatAudioButtonConfiguration {
        guard let audioOptions = tools?.chat?.audioCallOption else {
            return .disabled
        }
        return .enabled(audioOptions)
    }

    private var chatVideoButtonConf: UserInterfacePresenterConfiguration.ChatVideoButtonConfiguration {
        guard let videoOptions = tools?.chat?.videoCallOption else {
            return .disabled
        }
        return .enabled(videoOptions)
    }
}

