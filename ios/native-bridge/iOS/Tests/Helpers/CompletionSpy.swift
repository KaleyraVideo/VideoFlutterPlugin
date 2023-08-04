// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation

class CompletionSpy<T> {

    public enum State<T> {
        case notCalled
        case called(withArgument: T)
    }

    private(set) var state: State<T> = .notCalled
    private(set) var invocations = [T]()

    init() {}

    var called: Bool {
        switch state {
            case .notCalled:
                return false
            default:
                return true
        }
    }

    func callable(_ arg: T) -> Void {
        state = .called(withArgument: arg)
        invocations.append(arg)
    }
}

extension CompletionSpy where T == Void {

    func callable() -> Void {
        state = .called
        invocations.append(())
    }
}

extension CompletionSpy.State: Equatable where T:Equatable {}

extension CompletionSpy.State where T == Void {

    static var called: CompletionSpy<T>.State<T> {
        CompletionSpy<T>.State<T>.called(withArgument: ())
    }
}
