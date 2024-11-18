// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import UIKit

class ViewControllerSpy: UIViewController {

    private var _presentedViewController: UIViewController?
    override var presentedViewController: UIViewController? {
        _presentedViewController
    }

    private(set) var presentInvocations = [(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)]()
    private(set) var dismissInvocations = [((animated: Bool, completion: (() -> Void)?))]()

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentInvocations.append((viewController: viewControllerToPresent, animated: flag, completion: completion))
        _presentedViewController = viewControllerToPresent
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissInvocations.append((animated: flag, completion: completion))
        _presentedViewController = nil
    }
}
