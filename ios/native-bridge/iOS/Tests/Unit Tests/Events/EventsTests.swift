// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class EventsTests: UnitTestCase {

    func testDescription() {
        assertThat(Events.accessTokenRequest.description, equalTo("accessTokenRequest"))
        assertThat(Events.callError.description, equalTo("callError"))
        assertThat(Events.callModuleStatusChanged.description, equalTo("callModuleStatusChanged"))
        assertThat(Events.chatError.description, equalTo("chatError"))
        assertThat(Events.chatModuleStatusChanged.description, equalTo("chatModuleStatusChanged"))
        assertThat(Events.iOSVoipPushTokenInvalidated.description, equalTo("iOSVoipPushTokenInvalidated"))
        assertThat(Events.iOSVoipPushTokenUpdated.description, equalTo("iOSVoipPushTokenUpdated"))
        assertThat(Events.setupError.description, equalTo("setupError"))
    }

    func testCaseIterable() {
        let allEvents = Events.allCases

        assertThat(allEvents, hasCount(8))
        assertThat(allEvents.contains(Events.accessTokenRequest), isTrue())
        assertThat(allEvents.contains(Events.callError), isTrue())
        assertThat(allEvents.contains(Events.callModuleStatusChanged), isTrue())
        assertThat(allEvents.contains(Events.chatError), isTrue())
        assertThat(allEvents.contains(Events.chatModuleStatusChanged), isTrue())
        assertThat(allEvents.contains(Events.iOSVoipPushTokenInvalidated), isTrue())
        assertThat(allEvents.contains(Events.iOSVoipPushTokenUpdated), isTrue())
        assertThat(allEvents.contains(Events.setupError), isTrue())
    }
}
