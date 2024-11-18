// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import UIKit

class PresentingViewControllerViewControllerPresenter: ViewControllerPresenter {

    // MARK: - Properties

    private unowned let presentingViewController: UIViewController

    var isPresenting: Bool {
        presentingViewController.presentedViewController != nil
    }

    // MARK: - Init

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }

    // MARK: - ViewControllerPresenter

    func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentingViewController.present(viewController, animated: flag, completion: completion)
    }

    func dismiss(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        viewController.dismiss(animated: flag, completion: completion)
    }

    func displayAlert(title: String, message: String, dismissButtonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: dismissButtonText, style: .cancel)
        alert.addAction(action)
        presentingViewController.present(alert, animated: true)
    }

    func dismissAll(animated flag: Bool, completion: (() -> Void)?) {
        presentingViewController.dismiss(animated: flag, completion: completion)
    }
}
