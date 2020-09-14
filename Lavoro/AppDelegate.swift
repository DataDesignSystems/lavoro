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
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if AuthUser.getAuthUser() != nil {
            presentUserFLow()
            LoginChatUser.registerUserForChat()
        } else {
            self.presentLoginFlow()
        }
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        LocationManager.shared.startLocation()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let refreshMessage = Notification.Name(NotificationKey.refreshMessageList.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeCountForUnreadMessage), name: refreshMessage, object: nil)
        registerForNotification()
        UIApplication.shared.registerForRemoteNotifications()
        updateBadgeCountForUnreadMessage()
        GMSPlacesClient.provideAPIKey(GPManager.key)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.redirectToCheckInOut(with: "31")
//        }
        return true
    }
    
    func registerForNotification() {
         if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().delegate = self
             UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                 if granted {
                     DispatchQueue.main.async {
                         UIApplication.shared.registerForRemoteNotifications()
                     }
                 }
             }
         } else {
             let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
             UIApplication.shared.registerUserNotificationSettings(settings)
             UIApplication.shared.registerForRemoteNotifications()
         }
     }

    
    func presentLoginFlow() {
        AuthUser.logout()
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
        let alPushNotificationService: ALPushNotificationService = ALPushNotificationService()
        alPushNotificationService.notificationArrived(to: application, with: userInfo)
        let notificationName = Notification.Name(NotificationKey.refreshMessageList.rawValue)
        NotificationCenter.default.post(name: notificationName, object: nil)
        updatebadgeCountFromPushInfo(userInfo: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        let alPushNotificationService: ALPushNotificationService = ALPushNotificationService()
        alPushNotificationService.notificationArrived(to: application, with: userInfo)
        updatebadgeCountFromPushInfo(userInfo: userInfo)
        let dispatchTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            let notificationName = Notification.Name(NotificationKey.refreshMessageList.rawValue)
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("Device token data :: \(deviceToken.description)")
        var deviceTokenString: String = ""
        for i in 0..<deviceToken.count
        {
            deviceTokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        NSLog("Device token :: \(deviceTokenString)")
        if (ALUserDefaultsHandler.getApnDeviceToken() != deviceTokenString)
        {
            let alRegisterUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
            alRegisterUserClientService.updateApnDeviceToken(withCompletion: deviceTokenString, withCompletion: { (response, error) in
               if error != nil {
                print("Error in Registration: \(String(describing: error))")
               }
                NSLog("Registration Response :: \(String(describing: response))")
            })
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

            let pushNotificationService = ALPushNotificationService()
            let userInfo = notification.request.content.userInfo

            if pushNotificationService.isApplozicNotification(userInfo) {
                pushNotificationService.notificationArrived(to: UIApplication.shared, with: userInfo)
                completionHandler([])
                return
            }
            completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

            let pushNotificationService = ALPushNotificationService()
            let userInfo = response.notification.request.content.userInfo
            if pushNotificationService.isApplozicNotification(userInfo) {
                pushNotificationService.notificationArrived(to: UIApplication.shared, with: userInfo)
                redirectToMessage(userInfo: userInfo)
                completionHandler()
                return
            }
            completionHandler()
     }

    
    @objc
    func updateBadgeCountForUnreadMessage() {
        guard let tabbarController = window?.rootViewController as? TabbarViewController else {
            return
        }
        
        ApplozicClient().getLatestMessages(false, withOnlyGroups: true, withCompletionHandler: { messageList, error in
            if let messageList = messageList as? [ALMessage] {
                var groupMessageThreads = [NSNumber]()
                for message in messageList {
                    if let groupId = message.groupId {
                        groupMessageThreads.append(groupId)
                    }
                }
                
                for (index, groupId) in groupMessageThreads.enumerated() {
                    ApplozicClient().markConversationRead(forGroup: groupId) { (response, error) in
                        if index == groupMessageThreads.count {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                let userService = ALUserService()
                                if let totalUnreadCount = userService.getTotalUnreadCount(), (tabbarController.tabBar.items?.count ?? 0) > 2 {
                                    if(totalUnreadCount.intValue > 0){
                                        UIApplication.shared.applicationIconBadgeNumber = totalUnreadCount.intValue
                                        tabbarController.messageTabbarItem()?.badgeValue = "\(totalUnreadCount)"
                                    }else{
                                        UIApplication.shared.applicationIconBadgeNumber = 0
                                        tabbarController.messageTabbarItem()?.badgeValue = nil
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
        
    func updatebadgeCountFromPushInfo(userInfo: [AnyHashable: Any]) {
        guard let tabbarController = window?.rootViewController as? UITabBarController else {
            return
        }
        if let userInfo = userInfo as? [String: Any] {
            print(userInfo)
            if let object = userInfo["AL_VALUE"] as? String {
                print(object)
                let data = object.data(using: .utf8)!
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any]
                    {
                        print(jsonObj)
                        if let unreadCount = jsonObj["totalUnreadCount"] as? Int {
                            print(unreadCount)
                            UIApplication.shared.applicationIconBadgeNumber = unreadCount
                            if((tabbarController.tabBar.items?.count ?? 0) > 2){
                                tabbarController.tabBar.items![2].badgeValue = "\(unreadCount)"
                            }
                        }
                        
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    func redirectToPublicProfile(with userId: String) {
        guard let tabbarController = window?.rootViewController as? UITabBarController else {
            return
        }
        if((tabbarController.tabBar.items?.count ?? 0) > 0){
            tabbarController.selectedIndex = 0
            if let nav = tabbarController.selectedViewController as? UINavigationController {
                PublicProfileViewController.showProfile(on: nav, profileId: userId)
            }
        }
    }
    
    func redirectToCheckInOut(with id: String) {
        guard let tabbarController = window?.rootViewController as? UITabBarController else {
            return
        }
        if((tabbarController.tabBar.items?.count ?? 0) > 0){
            tabbarController.selectedIndex = 0
            if let nav = tabbarController.selectedViewController as? UINavigationController {
                FeedDetailViewController.showFeedDetail(on: nav, feed: Feed(with: ["id": id]))
            }
        }
        
    }
    
    func redirectToMessage(userInfo: [AnyHashable: Any]) {
        guard let tabbarController = window?.rootViewController as? UITabBarController else {
            return
        }
        if let userInfo = userInfo as? [String: Any] {
            print(userInfo)
            if let object = userInfo["AL_VALUE"] as? String {
                print(object)
                let data = object.data(using: .utf8)!
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any]
                    {
                        print(jsonObj)
                        if let messageMetadata = jsonObj["messageMetaData"] as? [String: Any] {
                            if let type = messageMetadata["type"] as? String {
                                if type == "public-profile", let userId = messageMetadata["user_id"] as? String  {
                                    self.redirectToPublicProfile(with: userId)
                                    return
                                } else if (type == "check-in" || type == "check-out"), let id = messageMetadata["id"] as? String {
                                    self.redirectToCheckInOut(with: id)
                                    return
                                }
                            }
                        }
                        if let userId = jsonObj["message"] as? String {
                            if((tabbarController.tabBar.items?.count ?? 0) > 2){
                                tabbarController.selectedIndex = 2
                                if let nav = tabbarController.selectedViewController as? UINavigationController, let messageVC = nav.topViewController as? MessageListViewController {
                                    messageVC.redirectToChat(with: userId)
                                }
                            }
                        }
                        
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
}

