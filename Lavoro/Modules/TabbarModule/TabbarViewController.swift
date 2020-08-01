//
//  TabbarViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    var tabInfo = [Tabbar(storyboardName: "Home", initialViewControllerIdentifier: "HomeModule", iconName: "ic_home", title: "Home"),
                   Tabbar(storyboardName: "Messages", initialViewControllerIdentifier: "MessagesModule", iconName: "ic_messages", title: "Messages"),
                   /*Tabbar(storyboardName: "Notification", initialViewControllerIdentifier: "NotificationModule", iconName: "ic_notification", title: "Notifications")*/]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let authUser = AuthUser.getAuthUser(), authUser.type == .serviceProvider {
            tabInfo.insert((Tabbar(storyboardName: "WorkCheckIn", initialViewControllerIdentifier: "WorkCheckInModule", iconName: "ic_workCheckIn", title: "Work Check In")), at: 1)
            tabInfo.append(Tabbar(storyboardName: "WhoIsWorking", initialViewControllerIdentifier: "WhoIsWorkingModule", iconName: "ic_notification", title: "Who Is Working"))
            tabInfo.append(Tabbar(storyboardName: "Profile", initialViewControllerIdentifier: "ProfileModule", iconName: "ic_profile", title: "Public"))
        }
        setupTabbar()
        self.delegate = self
        setupCheckInStatusText()
        // Do any additional setup after loading the view.
    }
    
    func setupCheckInStatusText() {
        guard let items = self.tabBar.items, items.count > 1 else {
            return
        }
        guard let authUser = AuthUser.getAuthUser(), authUser.type == .serviceProvider else {
            return
        }
        let checkinTabbar = items[1]
        if authUser.isAlreadyCheckIn() {
            checkinTabbar.title = "Work Check Out"
        } else {
            checkinTabbar.title = "Work Check In"
        }
    }
    
    func setupTabbar() {
        var viewControllerList = [UIViewController]()
        for tab in tabInfo {
            let storyBoard: UIStoryboard = UIStoryboard(name: tab.storyboardName, bundle: nil)
            let initialVC = storyBoard.instantiateViewController(withIdentifier: tab.initialViewControllerIdentifier) as! UINavigationController
            initialVC.title = tab.title
            initialVC.tabBarItem.image = UIImage(named: tab.iconName)
            viewControllerList.append(initialVC)
        }
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 10)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        UITabBar.appearance().tintColor = UIColor(red:0.91, green:0.00, blue:0.24, alpha:1.0)
        viewControllers = viewControllerList

    }
    
    func presentWebCheckIn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "WorkCheckIn", bundle: nil)
        let initialVC = storyBoard.instantiateViewController(withIdentifier: "WorkCheckInModule") as? UINavigationController ?? UIViewController()
        initialVC.modalPresentationStyle = .fullScreen
        self.present(initialVC, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func showProfileTab() {
        if let tabbarItems = self.tabBar.items, tabbarItems.count >= 5 {
            self.selectedIndex = 4
        }
    }
    
    func showWhoIFollow() {
        if let tabbarItems = self.tabBar.items, tabbarItems.count >= 5 {
            self.selectedIndex = 4
            if let profileNC = viewControllers?[4] as? UINavigationController, let profileVC = profileNC.topViewController as? ProfileViewController {
                profileVC.displayWhoIFollowPage()
            }
        }
    }
    
    func messageTabbarItem() -> UITabBarItem? {
        guard let authUser = AuthUser.getAuthUser() else {
            return nil
        }
        guard let items = tabBar.items else {
            return nil
        }
        if authUser.type == .serviceProvider, items.count >= 2 {
            return items[2]
        } else if items.count >= 1 {
            return items[1]
        } else {
            return nil
        }
    }
}

struct Tabbar {
    var storyboardName: String
    var initialViewControllerIdentifier: String
    var iconName: String
    var title: String
}

extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let nc = viewController as? UINavigationController, let _ = nc.viewControllers.first as? WorkCheckInViewController {
            presentWebCheckIn()
            return false
        }
        if let nc = viewController as? UINavigationController, let _ = nc.viewControllers.first as? ProfileViewController {
            guard let profileId = AuthUser.getAuthUser()?.id else {
                return false
            }
            guard let nav = self.selectedViewController as? UINavigationController else {
                return false
            }
            PublicProfileViewController.showProfile(on: nav, profileId: profileId)
            return false
        }
        return true
    }
}
