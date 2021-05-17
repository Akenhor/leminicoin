//
//  AppDelegate.swift
//  leminicoin
//
//  Created by Pierre Semler on 14/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {} else {
            var window: UIWindow?
            window = UIWindow(frame: UIScreen.main.bounds)
            
            let adListViewController = AdListViewController(nibName: nil, bundle: nil)
            let nvc = UINavigationController(rootViewController: adListViewController)
            nvc.navigationBar.barTintColor = AppColor.primaryColor.color
            nvc.navigationBar.tintColor = .white
            nvc.navigationBar.barStyle = .blackTranslucent
            
            window?.rootViewController = nvc
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

