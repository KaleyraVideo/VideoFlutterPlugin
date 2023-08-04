// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest

public func isSuccess<T, E>() -> Matcher<Result<T, E>> where E: Error {
    return isSuccess(withValue: anything())
}

public func isSuccess<T, E>(withValue matcher: Matcher<Any>) -> Matcher<Result<T, E>> where E: Error {
    var expectedDesc = "Success"
    if !matcher.description.isEmpty {
        expectedDesc += " with value " + matcher.description
    }
    return Matcher(expectedDesc) { (r: Result<T, E>) -> MatchResult in
        switch r {
            case .success(let value):
                return matcher.matches(value)
            case .failure(_):
                return .mismatch("Expected success got failure instead")
        }
    }
}

public func isSuccess<T, E>(withValue matcher: Matcher<T>) -> Matcher<Result<T, E>> where E: Error {
    var expectedDesc = "Success"
    if !matcher.description.isEmpty {
        expectedDesc += " with value " + matcher.description
    }
    return Matcher(expectedDesc) { (r: Result<T, E>) -> MatchResult in
        switch r {
            case .success(let value):
                return matcher.matches(value)
            case .failure(_):
                return .mismatch("Expected success got failure instead")
        }
    }
}

public func isFailure<T, E>() -> Matcher<Result<T, E>> where E: Error {
    return isFailure(withError: anything())
}

public func isFailure<T, E>(withError matcher: Matcher<Any>) -> Matcher<Result<T, E>> where E: Error {
    var expectedDesc = "Failure"
    if !matcher.description.isEmpty {
        expectedDesc += " with error " + matcher.description
    }
    return Matcher(expectedDesc) { (r: Result<T, E>) -> MatchResult in
        switch r {
            case .success(_):
                return .mismatch("Expected failure got success instead")
            case .failure(let error):
                return matcher.matches(error)
        }
    }
}
