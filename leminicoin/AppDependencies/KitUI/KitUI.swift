//
//  KitUI.swift
//  leminicoin
//
//  Created by Pierre Semler on 15/05/2021.
//

import Foundation
import UIKit

protocol KitUIDependency {
    static func showLoader()
    static func hideLoader()
    static func showError(on viewController: UIViewController, title: String, message: String?, buttonTitle: String, completion: @escaping () -> ())
}

class KitUI: KitUIDependency {
    fileprivate(set) static var loader: Loader = Loader()
    
    static func showLoader() {
        loader.show()
    }
    
    static func hideLoader() {
        loader.hide()
    }
    
    static func showError(on viewController: UIViewController, title: String, message: String?, buttonTitle: String, completion: @escaping () -> ()) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .cancel) { _ in
            completion()
        }
        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true)
    }
}
