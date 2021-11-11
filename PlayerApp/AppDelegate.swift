//
//  AppDelegate.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = RootNavController()
        window?.makeKeyAndVisible()
        return true
    }
}
