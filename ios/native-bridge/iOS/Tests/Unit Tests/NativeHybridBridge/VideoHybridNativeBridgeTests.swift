// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
import KaleyraVideoSDK
import PushKit
@testable import KaleyraVideoHybridNativeBridge

final class VideoHybridNativeBridgeTests: UnitTestCase {

    private var sut: VideoHybridNativeBridgeSpy!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = makeSUT()
    }

    override func tearDownWithError() throws {
        KaleyraVideo.logLevel = .off
        KaleyraVideo.instance.reset()
        sut = nil

        try super.tearDownWithError()
    }

    // MARK: - Init

    func testConvenientInit() {
        let sutSpy = VideoHybridNativeBridgeInitSpy(emitter: EventEmitterSpy(),
                                                    rootViewController: nil) {
            AccessTokenProviderStub()
        }

        assertThat(sutSpy.uiPresenter, instanceOf(MainQueueRelay<KaleyraVideoSDKUserInterfacePresenter>.self))
    }

    // MARK: - Configure SDK

    func testConfigureSDKShouldConfigureBandyerSDK() throws {
        let config = makeKaleyraVideoConfiguration()
        let expectedSdkConfig = try config.makeKaleyraVideoSDKConfig()

        try sut.configureSDK(config)
        assertThat(sut.sdkSpy.configureInvocations, hasCount(1))
        let sdkConf = try unwrap(sut.sdkSpy.configureInvocations.first)

        assert(config: sdkConf, equalTo: expectedSdkConfig)
    }

    func testConfigureSDKShouldConfigureConference() throws {
        let sut = VideoHybridNativeBridge(emitter: EventEmitterDummy(), rootViewController: nil) { AccessTokenProviderStub() }
        let config = makeKaleyraVideoConfiguration()
        let expectedTools = config.makeToolsConfig()

        try sut.configureSDK(config)

        assertThat(KaleyraVideo.instance.conference?.settings.tools, presentAnd(equalTo(expectedTools)))
    }

    func testConfigureSDKShouldSetUserDetailsProvider() throws {
        let config = makeKaleyraVideoConfiguration()

        try sut.configureSDK(config)

        assertThat(sut.sdkSpy.userDetailsProvider, present())
    }

    func testConfigureSDKWithLogEnabledShouldEnableLoggingOnSDK() throws {
        let config = makeKaleyraVideoConfiguration(logEnabled: true)

        try sut.configureSDK(config)

        assertThat(KaleyraVideo.logLevel, equalTo(.all))
    }

    func testConfigureSDKShouldStartEventsReporter() throws {
        let config = makeKaleyraVideoConfiguration()

        try sut.configureSDK(config)

        assertThat(sut.reporterSpy.startInvocations, hasCount(1))
    }

    func testConfigureSDKShouldConfigureUIPresenter() throws {
        let audioOptions = makeAudioCallOptions()
        let videoOptions = makeCallOptions()
        let config = makeKaleyraVideoConfiguration(feedback: true,
                                                    audioCallOption: audioOptions,
                                                    videoCallOption: videoOptions)

        try sut.configureSDK(config)

        assertThat(sut.uiPresenterSpy.configureInvocations, hasCount(1))
        assertThat(sut.uiPresenterSpy.configureInvocations.first?.showsFeedbackWhenCallEnds, presentAnd(isTrue()))
        assertThat(sut.uiPresenterSpy.configureInvocations.first?.chatAudioButtonConf, presentAnd(equalTo(.enabled(audioOptions))))
        assertThat(sut.uiPresenterSpy.configureInvocations.first?.chatVideoButtonConf, presentAnd(equalTo(.enabled(videoOptions))))
    }

    // MARK: - Call Client

    func testCallClientStateDescriptionShouldThrowIfCalledBeforeConfiguration() {
        assertThrows(try sut.callClientStateDescription(), equalTo(VideoHybridNativeBridgeError.sdkNotConfiguredError()))
    }

    func testCallClientStateDescriptionShouldReturnActualCallClientStateDescriptionString() throws {
        try configureSUT()

        sut.sdkSpy.conferenceStub.state = .disconnected(error: nil)
        assertThat(try sut.callClientStateDescription(), equalTo(KaleyraVideoSDK.ClientState.disconnected(error: nil).description))

        sut.sdkSpy.conferenceStub.state = .connecting
        assertThat(try sut.callClientStateDescription(), equalTo(KaleyraVideoSDK.ClientState.connecting.description))

        sut.sdkSpy.conferenceStub.state = .connected
        assertThat(try sut.callClientStateDescription(), equalTo(KaleyraVideoSDK.ClientState.connected.description))

        sut.sdkSpy.conferenceStub.state = .reconnecting
        assertThat(try sut.callClientStateDescription(), equalTo(KaleyraVideoSDK.ClientState.reconnecting.description))

        sut.sdkSpy.conferenceStub.state = .disconnected(error: anyNSError())
        assertThat(try sut.callClientStateDescription(), equalTo(KaleyraVideoSDK.ClientState.disconnected(error: anyNSError()).description))
    }

    // MARK: - Connect

    func testConnectShouldThrowIfCalledBeforeConfiguration() {
        assertThrows(try sut.connect(userID: "user_id"), equalTo(VideoHybridNativeBridgeError.sdkNotConfiguredError()))
    }

    func testConnectShouldUseAccessTokenProviderFactory() throws {
        try configureSUT()
        try sut.connect(userID: "user_id")

        assertThat(sut.accessTokenProviderFactorySpy.madeAccessTokenProviders, hasCount(1))
    }

    func testConnectShouldConnectBandyerSDK() throws {
        try configureSUT()
        try sut.connect(userID: "user_id")

        assertThat(sut.sdkSpy.connectInvocations, hasCount(1))
        assertThat(sut.sdkSpy.connectInvocations.first?.userId, presentAnd(equalTo("user_id")))
    }

    // MARK: - VoIP Push Token

    func testGetCurrentVoIPPushTokenShouldThrowIfCalledBeforeConfiguration() {
        assertThrows(try sut.getCurrentVoIPPushToken())
    }

    func testGetCurrentVoIPPushTokenShouldReturnLastReceivedVoIPPushToken() throws {
        let config = makeKaleyraVideoConfiguration(voipStrategy: .automatic)
        let token = "5b4b68e78c03e2d3b4a7e29e2b7d4429aa497538ac6c8520c6a7c278b5e4047e"

        try sut.configureSDK(config)
        sut.reporterSpy.mockVoIPToken(token)
        let lastToken = try sut.getCurrentVoIPPushToken()

        assertThat(lastToken, presentAnd(equalTo(token)))
    }

    // MARK: - Start Call

    func testStartCallShouldThrowIfCalledBeforeConfiguration() {
        assertThrows(try sut.startCall(makeCreateCallOptions()), equalTo(VideoHybridNativeBridgeError.sdkNotConfiguredError()))
    }

    func testStartCallShouldPresentCallUIUsingUIPresenter() throws {
        let options = makeCreateCallOptions()

        try configureSUT()
        try sut.startCall(options)

        assertThat(sut.uiPresenterSpy.presentCallWithOptionsInvocations, hasCount(1))
        assertThat(sut.uiPresenterSpy.presentCallWithOptionsInvocations.first, presentAnd(equalTo(options)))
    }

    // MARK: - Start Chat

    func testStartChatShouldThrowIfCalledBeforeConfiguration() {
        assertThrows(try sut.startChat("user_id"), equalTo(VideoHybridNativeBridgeError.sdkNotConfiguredError()))
    }

    func testStartChatShouldPresentChatUIUsingUIPresenter() throws {
        try configureSUT()
        try sut.startChat("user_id")

        assertThat(sut.uiPresenterSpy.presentChatInvocations, equalTo(["user_id"]))
    }

    // MARK: - Start Call Url

    func testStartCallUrlShouldThrowIfCalledBeforeConfiguration() {
        assertThrows(try sut.startCallUrl(makeAnyURL()), equalTo(VideoHybridNativeBridgeError.sdkNotConfiguredError()))
    }

    func testStartCallUrlShouldPresentCallUIUsingUIPresenter() throws {
        let url = makeAnyURL()

        try configureSUT()
        try sut.startCallUrl(url)

        assertThat(sut.uiPresenterSpy.presentCallWithURLInvocations, equalTo([url]))
    }

    // MARK: - Disconnect

    func testDisconnectShouldThrowIfCalledBeforeConfiguration() {
        assertThrows(try sut.disconnect(), equalTo(VideoHybridNativeBridgeError.sdkNotConfiguredError()))
    }

    func testDisconnectShouldMakeBandyerSDKDisconnect() throws {
        try configureSUT()
        try sut.disconnect()

        assertThat(sut.sdkSpy.disconnectInvocations, hasCount(1))
    }

    func testDisconnectShouldNotStopEventReporter() throws {
        try configureSUT()
        try sut.disconnect()

        assertThat(sut.reporterSpy.stopInvocations, hasCount(0))
    }

    // MARK: - Add UsersDetails

    func testAddUsersDetailsWithListShouldSetItemsOnUserCache() throws {
        let user = makeUserDetails()

        sut.addUsersDetails([user])

        assertThat(sut.usersCacheSpy.setItemsInvocations, hasCount(1))
        assertThat(sut.usersCacheSpy.setItemsInvocations.first, presentAnd(hasCount(1)))
        assertThat(sut.usersCacheSpy.setItemsInvocations.first?.first, presentAnd(equalTo(user.bandyerDetails)))
    }

    // MARK: - Remove UsersDetails

    func testRemoveUsersDetailsShouldPurgeUserCache() {
        sut.removeUsersDetails()

        assertThat(sut.usersCacheSpy.purgeInvocations, hasCount(1))
    }

    // MARK: - Reset

    func testResetShouldResetBandyerSDK() {
        sut.reset()

        assertThat(sut.sdkSpy.resetInvocations, hasCount(1))
    }

    // MARK: - Helpers

    private func makeSUT() -> VideoHybridNativeBridgeSpy {
        .init()
    }

    private func makeKaleyraVideoConfiguration(voipStrategy: VoipHandlingStrategy = .disabled,
                                               logEnabled: Bool = false,
                                               feedback: Bool = false,
                                               audioCallOption: AudioCallOptions? = nil,
                                               videoCallOption: KaleyraVideoHybridNativeBridge.CallOptions? = nil) -> KaleyraVideoConfiguration {
        .init(appID: "app_id",
              environment: .init(name: "sandbox"),
              iosConfig: .init(callkit: .init(appIconName: "app_icon",
                                              enabled: true,
                                              ringtoneSoundName: "ringtone"),
                               voipHandlingStrategy: voipStrategy),
              logEnabled: logEnabled,
              region: .init(name: "europe"),
              tools: .init(chat: .init(audioCallOption: audioCallOption, videoCallOption: videoCallOption),
                           feedback: feedback,
                           fileShare: false,
                           screenShare: .init(inApp: false,
                                              wholeDevice: false),
                           whiteboard: false))
    }

    private func makeCreateCallOptions() -> CreateCallOptions {
        .init(callees: ["bob", "alice"], callType: .audioVideo, recordingType: RecordingType.none)
    }

    private func makeAnyURL() -> URL {
        .init(string: "https://www.kaleyra.com")!
    }

    private func makeUserDetails() -> KaleyraVideoHybridNativeBridge.UserDetails {
        .init(imageURL: nil, name: nil, userID: "user_id")
    }

    private func makeCallDummy() -> CallDummy {
        .init()
    }

    private func makeAudioCallOptions() -> AudioCallOptions {
        .init(recordingType: .manual, type: .audioUpgradable)
    }

    private func makeCallOptions() -> KaleyraVideoHybridNativeBridge.CallOptions {
        .init(recordingType: .automatic)
    }

    private func configureSUT() throws {
        try sut.configureSDK(makeKaleyraVideoConfiguration())
    }

    private func makeCredentials(token: String) -> PKPushCredentials {
        FakePushCredentials(data: (token as NSString).tokenData())
    }

    // MARK: - Assertions

    func assert(config: KaleyraVideoSDK.Config, equalTo otherConfig: KaleyraVideoSDK.Config) {
        assertThat(config.appID, equalTo(otherConfig.appID))
        assertThat(config.region, equalTo(otherConfig.region))
        assertThat(config.environment, equalTo(otherConfig.environment))
        assertThat(config.callKit, equalTo(otherConfig.callKit))
        assertThat(config.voip, equalTo(otherConfig.voip))
        assertThat(config.shouldListenForDirectIncomingCalls, equalTo(otherConfig.shouldListenForDirectIncomingCalls))
    }
}

private class AccessTokenProviderFactorySpy {

    private(set) var madeAccessTokenProviders = [AccessTokenProviderStub]()

    lazy var accessTokenProviderFactory: () -> AccessTokenProvider = { [weak self] in
        let provider = AccessTokenProviderStub()
        self?.madeAccessTokenProviders.append(provider)
        return provider
    }
}

private class VideoHybridNativeBridgeSpy: VideoHybridNativeBridge {

    let sdkSpy: KaleyraVideoSDKProtocolSpy = .init()
    let reporterSpy: SDKEventReporterSpy = .init()
    let uiPresenterSpy: UserInterfacePresenterSpy = .init()
    let usersCacheSpy: UsersDetailsCacheSpy = .init()
    let accessTokenProviderFactorySpy: AccessTokenProviderFactorySpy = .init()

    init() {
        super.init(sdk: sdkSpy,
                   reporter: reporterSpy,
                   emitter: EventEmitterDummy(),
                   uiPresenter: uiPresenterSpy,
                   usersCache: usersCacheSpy,
                   accessTokenProviderFactory: accessTokenProviderFactorySpy.accessTokenProviderFactory)
    }
}

private class VideoHybridNativeBridgeInitSpy: VideoHybridNativeBridge {

    let uiPresenter: UserInterfacePresenter

    override init(sdk: any KaleyraVideoSDKProtocol, 
                  reporter: any SDKEventReporter,
                  emitter: any EventEmitter,
                  uiPresenter: any UserInterfacePresenter,
                  usersCache: UsersDetailsCache,
                  accessTokenProviderFactory: @escaping () -> any AccessTokenProvider) {
        self.uiPresenter = uiPresenter

        super.init(sdk: sdk, reporter: reporter,
                   emitter: emitter,
                   uiPresenter: uiPresenter,
                   usersCache: usersCache,
                   accessTokenProviderFactory: accessTokenProviderFactory)
    }
}

private class SDKEventReporterSpy: SDKEventReporter {

    private(set) var startInvocations: [()] = []
    private(set) var stopInvocations: [()] = []

    private(set) var lastVoIPToken: String?

    func start() {
        startInvocations.append(())
    }

    func stop() {
        stopInvocations.append(())
    }

    func mockVoIPToken(_ token: String) {
        lastVoIPToken = token
    }
}

private class AccessTokenProviderStub: AccessTokenProvider {

    func provideAccessToken(userId: String, completion: @escaping (Result<String, Error>) -> Void) {}
}

private class UsersDetailsCacheSpy: UsersDetailsCache {

    private(set) var setItemsInvocations = [[KaleyraVideoSDK.UserDetails]]()
    private(set) var purgeInvocations: [()] = []

    override func setItems(_ items: [KaleyraVideoSDK.UserDetails]) {
        setItemsInvocations.append(items)
    }

    override func purge() {
        purgeInvocations.append(())
    }
}
