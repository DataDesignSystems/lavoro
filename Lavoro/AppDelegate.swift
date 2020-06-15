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
import Applozic

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
        let refreshMessage = Notification.Name(NotificationKey.refreshMessageList.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeCountForUnreadMessage), name: refreshMessage, object: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateBadgeCountForUnreadMessage()
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notificationName = Notification.Name(NotificationKey.refreshMessageList.rawValue)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        let alPushNotificationService: ALPushNotificationService = ALPushNotificationService()
        alPushNotificationService.notificationArrived(to: application, with: userInfo)
        let dispatchTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            let notificationName = Notification.Name(NotificationKey.refreshMessageList.rawValue)
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    @objc
    func updateBadgeCountForUnreadMessage() {
        guard let tabbarController = window?.rootViewController as? UITabBarController else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let userService = ALUserService()
            if let totalUnreadCount = userService.getTotalUnreadCount(), (tabbarController.tabBar.items?.count ?? 0) > 2 {
                if(totalUnreadCount.intValue > 0){
                    UIApplication.shared.applicationIconBadgeNumber = totalUnreadCount.intValue
                    tabbarController.tabBar.items![2].badgeValue = "\(totalUnreadCount)"
                }else{
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    tabbarController.tabBar.items![2].badgeValue = nil
                }
            }
        }
    }
}

