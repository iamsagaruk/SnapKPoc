//
//  AppDelegate.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationViewController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navigationViewController = UINavigationController()
        navigationViewController?.pushViewController(ViewController(), animated: true)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationViewController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        return true
    }
}

