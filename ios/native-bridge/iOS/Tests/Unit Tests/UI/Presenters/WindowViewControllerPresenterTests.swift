// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import Hamcrest
@testable import KaleyraVideoHybridNativeBridge

final class WindowViewControllerPresenterTests: UnitTestCase {

    // MARK: - Init

    func testDefaultWindowFactory() {
        let sut = makeSUT()

        let window = sut.windowFactory()

        assertThat(window.windowLevel, equalTo(.normal + 1))
        assertThat(window.backgroundColor, equalTo(.clear))
    }

    func testDefaultRootViewControllerFactory() {
        let sut = makeSUT()

        let rootViewController = sut.rootViewControllerFactory()

        assertThat(rootViewController.view.backgroundColor, nilValue())
    }

    // MARK: - Present View Controller

    func testPresentShouldUseWindowFactoryForCreateAndShowANewWindow() {
        let viewController = makeViewController()
        let spy = makeWindowFactorySpy()
        let sut = makeSUT()

        sut.windowFactory = spy.factory
        sut.present(viewController, animated: false, completion: nil)

        assertThat(spy.madeWindows, hasCount(1))
        assertThat(spy.madeWindows.first?.isKeyWindow, presentAnd(isTrue()))
        assertThat(spy.madeWindows.first?.isHidden, presentAnd(isFalse()))
        assertThat(spy.madeWindows.first?.alpha, presentAnd(greaterThan(0)))
    }

    func testPresentShouldUseRootViewControllerFactoryForCreatingTheWindowRootViewController() throws {
        let viewController = makeViewController()
        let windowFacroySpy = makeWindowFactorySpy()
        let viewControllerFacroySpy = makeViewControllerFactorySpy()
        let sut = makeSUT()

        sut.windowFactory = windowFacroySpy.factory
        sut.rootViewControllerFactory = viewControllerFacroySpy.factory
        sut.present(viewController, animated: false, completion: nil)
        let presentedWindow = try unwrap(windowFacroySpy.madeWindows.first)

        assertThat(presentedWindow.rootViewController, present())
        assertThat(viewControllerFacroySpy.madeViewControllers, hasCount(1))
        assertThat(presentedWindow.rootViewController, equalTo(viewControllerFacroySpy.madeViewControllers.first))
    }

    func testShouldKeepAStrongReferenceToCreatedPresentedWindows() throws {
        let window = UIWindow()
        let sut = makeSUT()

        sut.windowFactory = { window }
        sut.present(makeViewController(), animated: false, completion: nil)

        assertThat(sut.showedWindows, hasCount(1))
        assertThat(sut.showedWindows.first, presentAnd(equalTo(window)))
    }

    func testIsPresentigShouldReturnTrueIfAViewControllerHasBeenPresentedOtherwiseFalse() {
        let viewController = makeViewController()
        let sut = makeSUT()

        assertThat(sut.isPresenting, isFalse())

        sut.present(viewController, animated: false, completion: nil)
        assertThat(sut.isPresenting, isTrue())
    }

    func testShouldUseWindowRootViewControllerForPresentingDesiredViewController() throws {
        let viewController = makeViewController()
        let viewControllerFacroySpy = makeViewControllerFactorySpy()
        let sut = makeSUT()

        sut.rootViewControllerFactory = viewControllerFacroySpy.factory
        sut.present(viewController, animated: false, completion: nil)
        let rootViewController = try unwrap(viewControllerFacroySpy.madeViewControllers.first)

        assertThat(rootViewController.presentInvocations, hasCount(1))
        assertThat(rootViewController.presentInvocations.first?.viewController, presentAnd(equalTo(viewController)))
        assertThat(rootViewController.presentInvocations.first?.animated, presentAnd(isFalse()))
    }

    func testRootViewControllerPresentingViewControllerCompletionShouldCallProvidedCompletion() throws {
        let completionSpy = CompletionSpy<Void>()
        let viewControllerFacroySpy = makeViewControllerFactorySpy()
        let sut = makeSUT()

        sut.rootViewControllerFactory = viewControllerFacroySpy.factory
        sut.present(makeViewController(), animated: false, completion: completionSpy.callable)
        let rootViewController = try unwrap(viewControllerFacroySpy.madeViewControllers.first)
        let presentInvocation = try unwrap(rootViewController.presentInvocations.first)
        presentInvocation.completion?()

        assertThat(completionSpy.invocations, hasCount(1))
    }

    func testPresentViewControllerShouldSetItsModalPresentationStyleToFullscreen() {
        let viewController = makeViewController()
        let sut = makeSUT()

        sut.present(viewController, animated: false, completion: nil)

        assertThat(viewController.modalPresentationStyle, equalTo(.fullScreen))
    }

    func testDismissViewControllerShouldCallDismissOnRootViewController() throws {
        let viewController = makeViewControllerMocked()
        let rootViewController = makeRootViewControllerSpy()
        let sut = makeSUT()

        sut.present(viewController, animated: false, completion: nil)
        viewController.mockRootViewController(rootViewController)
        sut.dismiss(viewController, animated: false, completion: nil)

        assertThat(rootViewController.dismissInvocations, hasCount(1))
        assertThat(rootViewController.dismissInvocations.first?.animated, presentAnd(isTrue()))
        assertThat(rootViewController.dismissInvocations.first?.completion, present())
    }

    func testOnViewControllerDismissCompletionShouldHideRelatedWindowAndReleaseItsReference() throws {
        let viewController = makeViewControllerMocked()
        let rootViewController = makeRootViewControllerSpy()
        let window = try unwrap(viewController.view.window)
        let sut = makeSUT()

        sut.windowFactory = { window }
        sut.rootViewControllerFactory = { rootViewController }
        sut.present(viewController, animated: false, completion: nil)
        viewController.mockRootViewController(rootViewController)
        sut.dismiss(viewController, animated: false, completion: nil)
        rootViewController.dismissInvocations.first?.completion?()

        assertThat(window.rootViewController, nilValue())
        assertThat(window.isHidden, isTrue())
        assertThat(sut.showedWindows, hasCount(0))
    }

    func testViewControllerDismissCompletionShouldCallProvidedCompletion() throws {
        let completionSpy = CompletionSpy<Void>()
        let viewController = makeViewControllerMocked()
        let rootViewController = makeRootViewControllerSpy()
        let sut = makeSUT()

        sut.rootViewControllerFactory = { rootViewController }
        sut.present(viewController, animated: false, completion: nil)
        viewController.mockRootViewController(rootViewController)
        sut.dismiss(viewController, animated: false, completion: completionSpy.callable)
        rootViewController.dismissInvocations.first?.completion?()

        assertThat(completionSpy.invocations, hasCount(1))
    }

    func testDismissAllShouldDismissAllPresentedViewControllers() throws {
        let viewController = makeViewControllerMocked()
        let rootViewController = makeRootViewControllerSpy()
        let window = try unwrap(viewController.view.window)
        let sut = makeSUT()

        sut.windowFactory = { window }
        sut.rootViewControllerFactory = { rootViewController }
        sut.present(viewController, animated: false, completion: nil)
        viewController.mockRootViewController(rootViewController)
        let completionSpy = CompletionSpy<Void>()
        sut.dismissAll(animated: false, completion: completionSpy.callable)
        rootViewController.dismissInvocations.first?.completion?()

        assertThat(sut.showedWindows, hasCount(0))
        assertThat(completionSpy.invocations, hasCount(1))
    }

    // MARK: - Display Alert

    func testDismissObservableAlertShouldCallOnDismissClosureOnDisappearing() {
        let spy = CompletionSpy<Void>()
        let dismissObservableAlert = WindowViewControllerPresenter.DismissObservableAlert()

        dismissObservableAlert.onDismiss = spy.callable
        dismissObservableAlert.viewDidDisappear(false)

        assertThat(spy.invocations, hasCount(1))
    }

    func testDisplayAlertShouldCreateADismissObservableAlertAndPresentIt() {
        let rootViewController = makeRootViewControllerSpy()
        let sut = makeSUT()

        sut.rootViewControllerFactory = { rootViewController }
        sut.displayAlert(title: "title", message: "message", dismissButtonText: "dismiss")

        assertThat(rootViewController.presentInvocations, hasCount(1))
        assertThat(rootViewController.presentInvocations.first?.viewController, presentAnd(instanceOf(WindowViewControllerPresenter.DismissObservableAlert.self)))
    }

    func testDisplayAlertShouldCorrectlyConfigureDismissObservableAlert() throws {
        let rootViewController = makeRootViewControllerSpy()
        let sut = makeSUT()

        sut.rootViewControllerFactory = { rootViewController }
        sut.displayAlert(title: "title", message: "message", dismissButtonText: "dismiss")
        let alert = try unwrap(rootViewController.presentInvocations.first?.viewController as? WindowViewControllerPresenter.DismissObservableAlert)

        assertThat(alert.title, presentAnd(equalTo("title")))
        assertThat(alert.message, presentAnd(equalTo("message")))
        assertThat(alert.actions, presentAnd(hasCount(1)))
        assertThat(alert.preferredStyle, presentAnd(equalTo(.alert)))
        assertThat(alert.actions.first?.title, presentAnd(equalTo("dismiss")))
        assertThat(alert.actions.first?.style, presentAnd(equalTo(.cancel)))
        assertThat(alert.onDismiss, present())
    }

    func testAlertOnDismissInvocationShouldHidePresentedWindow() throws {
        let rootViewController = makeRootViewControllerSpy()
        let window = UIWindow()
        let sut = makeSUT()

        sut.windowFactory = { window }
        sut.rootViewControllerFactory = { rootViewController }
        sut.displayAlert(title: "title", message: "message", dismissButtonText: "dismiss")
        let alert = try unwrap(rootViewController.presentInvocations.first?.viewController as? WindowViewControllerPresenter.DismissObservableAlert)
        alert.onDismiss?()

        assertThat(window.rootViewController, nilValue())
        assertThat(window.isHidden, isTrue())
        assertThat(sut.showedWindows, hasCount(0))
    }

    // MARK: - Helpers

    private func makeSUT() -> WindowViewControllerPresenter {
        .init()
    }

    private func makeViewController() -> UIViewController {
        .init()
    }

    private func makeWindowFactorySpy() -> WindowFactorySpy {
        .init()
    }

    private func makeViewControllerFactorySpy() -> ViewControllerFactorySpy {
        .init()
    }

    private func makeRootViewControllerSpy() -> ViewControllerSpy {
        .init()
    }

    private func makeViewControllerMocked() -> ViewController_WindowRootViewControllerMocked {
        .init()
    }
}

private class WindowFactorySpy {

    private(set) var madeWindows = [UIWindow]()

    lazy var factory: () -> UIWindow = { [weak self] in
        {
            let window = UIWindow()
            self?.madeWindows.append(window)
            return window
        }
    }()
}

private class ViewControllerFactorySpy {

    private(set) var madeViewControllers = [ViewControllerSpy]()

    lazy var factory: () -> UIViewController = { [weak self] in
        {
            let viewController = ViewControllerSpy()
            viewController.loadViewIfNeeded()
            self?.madeViewControllers.append(viewController)
            return viewController
        }
    }()
}

private class ViewController_WindowRootViewControllerMocked: UIViewController {

    private class MockedWindow: UIWindow {

        private var _rootViewController: UIViewController?

        override var rootViewController: UIViewController? {
            get {
                _rootViewController
            }
            set {
                _rootViewController = newValue
            }
        }
    }

    private class MockedView: UIView {

        private var _window: UIWindow?

        override var window: UIWindow? {
            get {
                _window
            }
            set {
                _window = newValue
            }
        }
    }

    private let mockedWindow = MockedWindow()
    private lazy var mockedView: MockedView = {
        let view = MockedView()
        view.window = mockedWindow
        return view
    }()

    override var view: UIView! {
        get {
            mockedView
        }
        set { }
    }

    func mockRootViewController(_ viewController: UIViewController) {
        mockedWindow.rootViewController = viewController
    }
}
