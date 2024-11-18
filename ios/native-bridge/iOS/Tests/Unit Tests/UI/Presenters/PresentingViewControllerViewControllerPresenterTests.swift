// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class PresentingViewControllerViewControllerPresenterTests: UnitTestCase {

    private var presentingViewController: ViewControllerSpy!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        presentingViewController = makeViewControllerSpy()
    }

    override func tearDownWithError() throws {
        presentingViewController = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testPresentShouldUsePresentingViewControllerToPresentDesiredViewController() {
        let viewController = makeViewController()
        let presentingViewController = makeViewControllerSpy()
        let sut = makeSUT(presentingViewController: presentingViewController)

        sut.present(viewController, animated: false, completion: nil)

        assertThat(presentingViewController.presentInvocations, hasCount(1))
        assertThat(presentingViewController.presentInvocations.first?.viewController, presentAnd(equalTo(viewController)))
        assertThat(presentingViewController.presentInvocations.first?.animated, presentAnd(isFalse()))
        assertThat(presentingViewController.presentInvocations.first?.completion, nilValue())
    }

    func testIsPresentigShouldReturnTrueIfAViewControllerHasBeenPresentedOtherwiseFalse() {
        let viewController = makeViewController()
        let sut = makeSUT()

        assertThat(sut.isPresenting, isFalse())

        sut.present(viewController, animated: false, completion: nil)
        assertThat(sut.isPresenting, isTrue())
    }

    func testDismissViewControllerShouldCallDismissOnDesiredViewController() {
        let viewController = makeViewControllerSpy()
        let sut = makeSUT()

        sut.dismiss(viewController, animated: false, completion: nil)

        assertThat(viewController.dismissInvocations, hasCount(1))
        assertThat(viewController.dismissInvocations.first?.animated, presentAnd(isFalse()))
        assertThat(viewController.dismissInvocations.first?.completion, nilValue())
    }

    func testDisplayAlertShouldPresentAnUIAlertController() {
        let presentingViewController = makeViewControllerSpy()
        let sut = makeSUT(presentingViewController: presentingViewController)

        sut.displayAlert(title: "title", message: "message", dismissButtonText: "dismiss")

        assertThat(presentingViewController.presentInvocations, hasCount(1))
        assertThat(presentingViewController.presentInvocations.first?.viewController, presentAnd(instanceOf(UIAlertController.self)))
        assertThat(presentingViewController.presentInvocations.first?.animated, presentAnd(isTrue()))
        assertThat(presentingViewController.presentInvocations.first?.completion, nilValue())
    }

    func testUIAlertControllerSetup() throws {
        let presentingViewController = makeViewControllerSpy()
        let sut = makeSUT(presentingViewController: presentingViewController)

        sut.displayAlert(title: "title", message: "message", dismissButtonText: "dismiss")
        let alert = try unwrap(presentingViewController.presentInvocations.first?.viewController as? UIAlertController)

        assertThat(alert.title, presentAnd(equalTo("title")))
        assertThat(alert.message, presentAnd(equalTo("message")))
        assertThat(alert.actions, presentAnd(hasCount(1)))
        assertThat(alert.preferredStyle, presentAnd(equalTo(.alert)))
        assertThat(alert.actions.first?.title, presentAnd(equalTo("dismiss")))
        assertThat(alert.actions.first?.style, presentAnd(equalTo(.cancel)))
    }

    func testDismissAllShouldInvokeDismissOnPresentingViewController() {
        let presentingViewController = makeViewControllerSpy()
        let sut = makeSUT(presentingViewController: presentingViewController)

        sut.present(makeViewController(), animated: false, completion: nil)
        sut.dismissAll(animated: false, completion: nil)

        assertThat(presentingViewController.dismissInvocations, hasCount(1))
        assertThat(presentingViewController.dismissInvocations.first?.animated, presentAnd(isFalse()))
    }

    // MARK: - Helpers

    private func makeSUT(presentingViewController: ViewControllerSpy? = nil) -> PresentingViewControllerViewControllerPresenter {
        let viewController: ViewControllerSpy

        if let presentingViewController = presentingViewController {
            viewController = presentingViewController
        } else {
            viewController = self.presentingViewController
        }

        return .init(presentingViewController: viewController)
    }

    private func makeViewControllerSpy() -> ViewControllerSpy {
        PresentingViewControllerViewControllerPresenterTests.makeViewControllerSpy()
    }

    private static func makeViewControllerSpy() -> ViewControllerSpy {
        .init()
    }

    private func makeViewController() -> UIViewController {
        .init()
    }
}
