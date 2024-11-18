// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import Foundation
import UIKit

protocol ViewControllerPresenter {

    var isPresenting: Bool { get }

    func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func displayAlert(title: String, message: String, dismissButtonText: String)

    func dismiss(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismissAll(animated flag: Bool, completion: (() -> Void)?)
}
