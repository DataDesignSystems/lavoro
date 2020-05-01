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
                   Tabbar(storyboardName: "WorkCheckIn", initialViewControllerIdentifier: "WorkCheckInModule", iconName: "ic_workCheckIn", title: "Work Check In"),
                   Tabbar(storyboardName: "Messages", initialViewControllerIdentifier: "MessagesModule", iconName: "ic_messages", title: "Messages"),
                   Tabbar(storyboardName: "Notification", initialViewControllerIdentifier: "NotificationModule", iconName: "ic_notification", title: "Notifications"),
                   Tabbar(storyboardName: "Profile", initialViewControllerIdentifier: "ProfileModule", iconName: "ic_profile", title: "Profile")]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        // Do any additional setup after loading the view.
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
}

struct Tabbar {
    var storyboardName: String
    var initialViewControllerIdentifier: String
    var iconName: String
    var title: String
}
