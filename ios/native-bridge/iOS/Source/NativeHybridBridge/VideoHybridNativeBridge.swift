// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import KaleyraVideoSDK

class VideoHybridNativeBridge {

    // MARK: - Properties

    private let sdk: KaleyraVideoSDKProtocol
    private let reporter: SDKEventReporter
    private let emitter: EventEmitter
    private let uiPresenter: UserInterfacePresenter
    private let usersCache: UsersDetailsCache
    private let accessTokenProviderFactory: () -> AccessTokenProvider

    private var isConfigured: Bool {
        sdk.config != nil
    }

    //  MARK: - Init

    init(sdk: KaleyraVideoSDKProtocol,
         reporter: SDKEventReporter,
         emitter: EventEmitter,
         uiPresenter: UserInterfacePresenter,
         usersCache: UsersDetailsCache,
         accessTokenProviderFactory: @escaping () -> AccessTokenProvider) {
        self.sdk = sdk
        self.reporter = reporter
        self.emitter = emitter
        self.uiPresenter = uiPresenter
        self.usersCache = usersCache
        self.accessTokenProviderFactory = accessTokenProviderFactory
    }

    convenience init(emitter: EventEmitter,
                     rootViewController: UIViewController?,
                     accessTokenProviderFactory: @escaping () -> AccessTokenProvider) {
        let sdk = KaleyraVideo.instance

        self.init(sdk: sdk,
                  reporter: EventsReporter(emitter: emitter, sdk: sdk),
                  emitter: emitter,
                  uiPresenter: MainQueueRelay(KaleyraVideoSDKUserInterfacePresenter(rootViewController: rootViewController)),
                  usersCache: .init(),
                  accessTokenProviderFactory: accessTokenProviderFactory)
    }

    // MARK: - Plugin Implementation

    func configureSDK(_ config: KaleyraVideoConfiguration) throws {

        if config.logEnabled ?? false {
            KaleyraVideo.logLevel = .all

        }

        let sdkConfig = try config.makeKaleyraVideoSDKConfig()

        sdk.userDetailsProvider = UsersDetailsProvider(cache: usersCache)
        try sdk.configure(sdkConfig)
        sdk.conference?.settings.tools = config.makeToolsConfig()

        reporter.start()

        uiPresenter.configure(with: config.uiPresenterConfiguration())
    }

    func callClientStateDescription() throws -> String {
        try checkIsConfigured()

        return sdk.conference?.state.description ?? ""
    }

    func connect(userID: String) throws {
        try checkIsConfigured()
        let provider = accessTokenProviderFactory()
        try sdk.connect(userId: userID, provider: provider)
    }

    func getCurrentVoIPPushToken() throws -> String? {
        try checkIsConfigured()

        return reporter.lastVoIPToken
    }

    func startCall(_ options: CreateCallOptions) throws {
        try checkIsConfigured()

        uiPresenter.presentCall(options)
    }

    func startChat(_ userID: String) throws {
        try checkIsConfigured()

        uiPresenter.presentChat(with: userID)
    }

    func startCallUrl(_ url: URL) throws {
        try checkIsConfigured()

        uiPresenter.presentCall(url)
    }

    func disconnect() throws {
        try checkIsConfigured()

        sdk.disconnect()
    }

    func addUsersDetails(_ details: [UserDetails]) {
        usersCache.setItems(details.map(\.bandyerDetails))
    }

    func removeUsersDetails() {
        usersCache.purge()
    }

    func reset() {
        sdk.reset()
    }

    // MARK: - Private Functions

    private func checkIsConfigured() throws {
        guard isConfigured else {
            throw VideoHybridNativeBridgeError.sdkNotConfiguredError()
        }
    }

    // MARK: - Unsupported Features on iOS Platform

    func clearUserCache() {
        debugPrint("clearUserCache() is not supported for iOS platform.")
    }

    func setDisplayModeForCurrentCall(_ mode: String) {
        debugPrint("setDisplayModeForCurrentCall(_) is not supported for iOS platform - mode: \(mode)")
    }
}
