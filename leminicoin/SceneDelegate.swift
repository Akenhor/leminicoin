//
//  SceneDelegate.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            
            let adListViewController = AdListViewController(nibName: nil, bundle: nil)
            let nvc = UINavigationController(rootViewController: adListViewController)
            nvc.navigationBar.barTintColor = .orange
            nvc.navigationBar.barStyle = .blackTranslucent
            
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
        }
    }
}

