//
//  AppDelegate.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if AuthUser.getAuthUser() != nil {
            presentUserFLow()
        } else {
            self.presentLoginFlow()
        }
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        LocationManager.shared.startLocation()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}

