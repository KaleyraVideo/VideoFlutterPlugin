// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import UIKit

@available(iOS 12.0, *)
class WindowViewControllerPresenter: ViewControllerPresenter {

    // MARK: - Nested Types

    class DismissObservableAlert: UIAlertController {

        var onDismiss: (() -> Void)?

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            onDismiss?()
        }
    }

    // MARK: - Properties

    var windowFactory: () -> UIWindow = {
        let window = UIWindow()
        window.windowLevel = .normal + 1
        window.backgroundColor = .clear
        return window
    }

    var rootViewControllerFactory: () -> UIViewController = {
        .init()
    }

    private(set) var showedWindows = [UIWindow]()

    private var presentedViewControllers: [UIViewController] {
        showedWindows.compactMap({ $0.rootViewController?.presentedViewController })
    }

    var isPresenting: Bool {
        !presentedViewControllers.isEmpty
    }

    // MARK: - ViewControllerPresenter

    func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        let window = windowFactory()
        let rootViewController = rootViewControllerFactory()

        window.makeKeyAndVisible()
        window.rootViewController = rootViewController

        if let alert = viewController as? DismissObservableAlert {
            alert.onDismiss = { [weak self, weak window] in
                guard let self = self, let window = window else { return }

                self.hideWindow(window)
            }
        } else {
            viewController.modalPresentationStyle = .fullScreen
        }

        rootViewController.present(viewController, animated: flag, completion: completion)

        showedWindows.append(window)
    }

    func dismiss(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        guard let window = viewController.view.window else { return }

        let continueWith = { [weak self] in
            self?.hideWindow(window)
            completion?()
        }

        if let rootViewController = window.rootViewController {
            rootViewController.dismiss(animated: true, completion: continueWith)
        } else {
            continueWith()
        }
    }

    func displayAlert(title: String, message: String, dismissButtonText: String) {
        let alert = DismissObservableAlert(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: dismissButtonText, style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func dismissAll(animated flag: Bool, completion: (() -> Void)?){
        guard let topPresented = presentedViewControllers.first else {
            completion?()
            return
        }

        if presentedViewControllers.count > 1 {
            dismiss(topPresented, animated: flag) { [weak self] in
                self?.dismissAll(animated: flag, completion: completion)
            }
        } else {
            dismiss(topPresented, animated: flag, completion: completion)
        }
    }

    private func hideWindow(_ window: UIWindow) {
        window.isHidden = true
        window.rootViewController = nil
        showedWindows.removeAll(where: { $0 == window })
    }
}
