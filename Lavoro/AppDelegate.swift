//
//  AppDelegate.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.presentUserFLow()
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func presentLoginFlow() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginFLow")
        self.window?.rootViewController = vc
    }
    
    func presentUserFLow() {
        self.window?.rootViewController = TabbarViewController()
    }
}

