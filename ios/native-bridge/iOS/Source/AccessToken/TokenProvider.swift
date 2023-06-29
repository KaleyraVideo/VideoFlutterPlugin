// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Bandyer

@available(iOS 12.0, *)
class TokenProvider: AccessTokenProvider {

    // MARK: - Nested Types

    private struct PendingRequest {

        let id: String
        let completion: (Result<String, Error>) -> Void

        init(id: UUID = .init(), completion: @escaping (Result<String, Error>) -> Void) {
            self.init(id: id.uuidString, completion: completion)
        }

        init(id: String, completion: @escaping (Result<String, Error>) -> Void) {
            self.id = id
            self.completion = completion
        }

        func succeeded(_ token: String) {
            completion(.success(token))
        }

        func failed(_ error: Error) {
            completion(.failure(error))
        }
    }

    private struct ProviderError: Error {

        let reason: String?
    }

    // MARK: - Properties

    private let requester: AccessTokenRequester

    private lazy var requests = [PendingRequest]()

    // MARK: - Init

    init(requester: AccessTokenRequester) {
        self.requester = requester
    }

    // MARK: - AccessTokenProvider

    func provideAccessToken(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let pendingRequest = PendingRequest(completion: completion)
        let request = AccessTokenRequest(requestID: pendingRequest.id, userID: userId)

        do {
            try requester.requestAccessToken(request: request)
        } catch {
            completion(.failure(error))
        }

        requests.append(pendingRequest)
    }

    func onResponse(_ response: AccessTokenResponse) {
        guard let request = requests.first(where: { $0.id == response.requestID }) else { return }

        if response.success {
            request.succeeded(response.data)
        } else {
            request.failed(ProviderError(reason: response.error))
        }

        requests.removeAll(where: { $0.id == response.requestID })
    }
}
