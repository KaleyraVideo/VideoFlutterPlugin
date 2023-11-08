// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class VideoHybridNativeBridge {

    // MARK: - Properties

    private let sdk: BandyerSDKProtocol
    private let reporter: SDKEventReporter
    private let emitter: EventEmitter
    private let uiPresenter: UserInterfacePresenter
    private let formatterProxy: FormatterProxy
    private let usersCache: UsersDetailsCache
    private let accessTokenProviderFactory: () -> AccessTokenProvider

    private var pushTokenEventReporter: PushTokenEventsReporter?

    private var isConfigured: Bool {
        sdk.config != nil
    }

    //  MARK: - Init

    init(sdk: BandyerSDKProtocol,
         reporter: SDKEventReporter,
         emitter: EventEmitter,
         uiPresenter: UserInterfacePresenter,
         formatterProxy: FormatterProxy,
         usersCache: UsersDetailsCache,
         accessTokenProviderFactory: @escaping () -> AccessTokenProvider) {
        self.sdk = sdk
        self.reporter = reporter
        self.emitter = emitter
        self.uiPresenter = uiPresenter
        self.formatterProxy = formatterProxy
        self.usersCache = usersCache
        self.accessTokenProviderFactory = accessTokenProviderFactory
    }

    convenience init(emitter: EventEmitter,
                     rootViewController: UIViewController?,
                     accessTokenProviderFactory: @escaping () -> AccessTokenProvider) {
        let sdk = BandyerSDK.instance
        let formatterProxy = FormatterProxy()

        self.init(sdk: sdk,
                  reporter: EventsReporter(emitter: emitter, sdk: sdk),
                  emitter: emitter,
                  uiPresenter: MainQueueRelay(KaleyraVideoSDKUserInterfacePresenter(rootViewController: rootViewController, formatter: formatterProxy)),
                  formatterProxy: formatterProxy,
                  usersCache: .init(),
                  accessTokenProviderFactory: accessTokenProviderFactory)
    }

    // MARK: - Plugin Implementation

    func configureSDK(_ config: KaleyraVideoConfiguration) throws {
        configurePushEventsReporterIfNeeded(config: config)

        if config.logEnabled ?? false {
            BandyerSDK.logLevel = .all
        }

        let sdkConfig = try config.makeBandyerConfig(registryDelegate: pushTokenEventReporter)

        sdk.userDetailsProvider = UsersDetailsProvider(cache: usersCache, formatter: formatterProxy)
        sdk.configure(sdkConfig)

        reporter.start()

        uiPresenter.configure(with: config.uiPresenterConfiguration())
    }

    func callClientStateDescription() throws -> String {
        try checkIsConfigured()

        return sdk.callClient.state.description
    }

    func connect(userID: String) throws {
        try checkIsConfigured()
        let provider = accessTokenProviderFactory()
        sdk.connect(Bandyer.Session(userId: userID, tokenProvider: provider))
    }

    func getCurrentVoIPPushToken() throws -> String? {
        try checkIsConfigured()

        return pushTokenEventReporter?.lastToken
    }

    func setUserDetailsFormat(_ format: UserDetailsFormat) {
        formatterProxy.formatter = UserDetailsFormatter(format: format.userDetailsFormatDefault)
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

    func verifyCurrentCall(_ verify: Bool) throws {
        try checkIsConfigured()
        guard let call = sdk.callRegistry.calls.first else { return }

        sdk.verifiedUser(verify, for: call, completion: nil)
    }

    func reset() {
        sdk.reset()
    }

    // MARK: - Private Functions

    private func configurePushEventsReporterIfNeeded(config: KaleyraVideoConfiguration) {
        guard config.voipStrategy == .automatic else { return }
        guard pushTokenEventReporter == nil else { return }

        pushTokenEventReporter = PushTokenEventsReporter(emitter: emitter)
    }

    private func checkIsConfigured() throws {
        guard isConfigured else {
            throw VideoHybridNativeBridgeError.sdkNotConfiguredError()
        }
    }

    // MARK: - Unsupported Features on iOS Platform

    func clearUserCache() {
        debugPrint("clearUserCache() is not supported for iOS platform.")
    }

    func handlePushNotificationPayload(_ json: String) {
        debugPrint("handlePushNotificationPayload(_) is not supported for iOS platform - json: \(json)")
    }

    func setDisplayModeForCurrentCall(_ mode: String) {
        debugPrint("setDisplayModeForCurrentCall(_) is not supported for iOS platform - mode: \(mode)")
    }
}
