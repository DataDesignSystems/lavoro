//
//  BaseNavigationViewController.swift
//  Lavoro
//
//  Created by Manish on 02/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let style = self.topViewController?.preferredStatusBarStyle {
            return style
        }
        return .default
    }
}
