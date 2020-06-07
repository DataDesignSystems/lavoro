//
//  BaseFacebookViewController.swift
//  Lavoro
//
//  Created by Manish on 07/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class BaseFacebookViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func facebookLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            print(result?.token)
        }
    }
}
