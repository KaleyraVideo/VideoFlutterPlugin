// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class TokenProviderTests: UnitTestCase {

    func testProvideAccessTokenShouldUseAccessTokenRequesterForMakeARequest() {
        let spy = makeAccessTokenRequesterSpy()
        let sut = makeSUT(requester: spy)

        sut.provideAccessToken(userId: "user_id") { _ in }

        assertThat(spy.requestAccessTokenInvocations, hasCount(1))
        assertThat(spy.requestAccessTokenInvocations.first?.userID, presentAnd(equalTo("user_id")))
    }

    func testRequesterThowingAnErrorShouldReportFailureInCompletion() {
        let completionSpy = CompletionSpy<Result<String, Error>>()
        let requester = ThrowingAccessTokenRequester()
        let sut = makeSUT(requester: requester)

        sut.provideAccessToken(userId: "user_id", completion: completionSpy.callable)

        assertThat(completionSpy.invocations, hasCount(1))
        assertThat(completionSpy.invocations.first, presentAnd(isFailure(withError: instanceOfAnd(equalTo(requester.error)))))
    }

    func testOnAccessTokenResponseShouldReportSuccessInCompletion() throws {
        let completionSpy = CompletionSpy<Result<String, Error>>()
        let spy = makeAccessTokenRequesterSpy()
        let sut = makeSUT(requester: spy)

        sut.provideAccessToken(userId: "user_id", completion: completionSpy.callable)
        let request = try unwrap(spy.requestAccessTokenInvocations.first)
        sut.onResponse(makeSuccessAccessTokenResponse(requestID: request.requestID, token: "token"))

        assertThat(completionSpy.invocations, hasCount(1))
        assertThat(completionSpy.invocations.first, presentAnd(isSuccess(withValue: equalTo("token"))))
    }

    func testOnAccessTokenResponseShouldDoNothingIfMismatchRequestId() {
        let completionSpy = CompletionSpy<Result<String, Error>>()
        let sut = makeSUT()

        sut.provideAccessToken(userId: "user_id", completion: completionSpy.callable)
        sut.onResponse(makeSuccessAccessTokenResponse(requestID: "mismatch_request_id", token: "token"))

        assertThat(completionSpy.invocations, hasCount(0))
    }

    func testOnFailureAccessTokenResponseShouldReportFailureInCompletion() throws {
        let completionSpy = CompletionSpy<Result<String, Error>>()
        let spy = makeAccessTokenRequesterSpy()
        let sut = makeSUT(requester: spy)

        sut.provideAccessToken(userId: "user_id", completion: completionSpy.callable)
        let request = try unwrap(spy.requestAccessTokenInvocations.first)
        sut.onResponse(makeFailureAccessTokenResponse(requestID: request.requestID))

        assertThat(completionSpy.invocations, hasCount(1))
        assertThat(completionSpy.invocations.first, presentAnd(isFailure()))
    }

    func testMultipleOnResposeInvocationShouldCallCompletionOnlyOnce() throws {
        let completionSpy = CompletionSpy<Result<String, Error>>()
        let spy = makeAccessTokenRequesterSpy()
        let sut = makeSUT(requester: spy)

        sut.provideAccessToken(userId: "user_id", completion: completionSpy.callable)
        let request = try unwrap(spy.requestAccessTokenInvocations.first)
        let response = makeSuccessAccessTokenResponse(requestID: request.requestID, token: "token")
        sut.onResponse(response)
        sut.onResponse(response)

        assertThat(completionSpy.invocations, hasCount(1))
    }

    // MARK: - Helpers

    private func makeSUT(requester: AccessTokenRequester = makeAccessTokenRequesterSpy()) -> TokenProvider {
        .init(requester: requester)
    }

    private func makeAccessTokenRequesterSpy() -> AccessTokenRequesterSpy {
        TokenProviderTests.makeAccessTokenRequesterSpy()
    }

    private static func makeAccessTokenRequesterSpy() -> AccessTokenRequesterSpy {
        .init()
    }

    private func makeSuccessAccessTokenResponse(requestID: String, token: String) -> AccessTokenResponse {
        .init(data: token, error: nil, requestID: requestID, success: true)
    }

    private func makeFailureAccessTokenResponse(requestID: String) -> AccessTokenResponse {
        .init(data: "", error: "error", requestID: requestID, success: false)
    }
}

private class AccessTokenRequesterSpy: AccessTokenRequester {

    private(set) var requestAccessTokenInvocations = [AccessTokenRequest]()

    func requestAccessToken(request: AccessTokenRequest) throws {
        requestAccessTokenInvocations.append(request)
    }
}

private class ThrowingAccessTokenRequester: AccessTokenRequester {

    struct AnyAccessTokenRequesterError: Error, Equatable {}

    let error = AnyAccessTokenRequesterError()

    func requestAccessToken(request: AccessTokenRequest) throws {
        throw error
    }
}
