//
//  BaseFacebookViewController.swift
//  Lavoro
//
//  Created by Manish on 07/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class BaseFacebookViewController: BaseViewController {
    let loginService = LoginService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //success, Authuser, isNewUser
    func facebookLogin(completionHandler: @escaping ((Bool, AuthUser?, Bool) -> ())) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            if let token = result?.token?.tokenString {
                self?.showLoadingView()
                let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                              parameters: ["fields": "email, first_name, last_name"],
                                                              tokenString: token,
                                                              version: nil,
                                                              httpMethod: .get)
                graphRequest.start { (connection, result, error) -> Void in
                    if error == nil {
                        if let result = result as? [String: Any], let id = result["id"] as? String {
                            self?.loginService.facebookAuthenticate(with: FBUser(firstName: result["first_name"] as? String,
                                                                                 lastName: result["last_name"] as? String,
                                                                                 email: result["email"] as? String,
                                                                                 token: id)){ [weak self] (success, message, authUser, isNewUser) in
                                self?.stopLoadingView()
                                if success {
                                    if isNewUser ?? true {
                                        completionHandler(success, authUser, isNewUser ?? true)
                                    } else {
                                        MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.loginSuccessfull.rawValue)
                                        completionHandler(success, authUser, false)
                                    }
                                } else if message?.isEmpty ?? true {
                                    self?.handleError(message: Validation.Error.genericError.rawValue, completionHandler: completionHandler)
                                } else {
                                    self?.handleError(message: message ?? "", completionHandler: completionHandler)
                                }
                            }
                        } else {
                            self?.handleError(message: Validation.Error.genericError.rawValue, completionHandler: completionHandler)
                        }
                    }
                    else {
                        self?.handleError(message: Validation.Error.genericError.rawValue, completionHandler: completionHandler)
                        print("error \(String(describing: error?.localizedDescription))")
                    }
                }
            } else {
                self?.handleError(message: Validation.Error.genericError.rawValue, completionHandler: completionHandler)
            }
        }
    }
    
    func handleError(message: String, completionHandler: @escaping ((Bool, AuthUser?, Bool) -> ())) {
        self.stopLoadingView()
        MessageViewAlert.showError(with: Validation.Error.genericError.rawValue)
        completionHandler(false, nil, true)
    }
    
    func appleLogin(userIdentifier: String, firstName: String, lastName: String, email: String, completionHandler: @escaping ((Bool, AuthUser?, Bool) -> ())) {
        self.showLoadingView()
        self.loginService.appleAuthenticate(with: userIdentifier, firstName: firstName, lastName: lastName, email: email) { [weak self] (success, message, authUser, isNewUser) in
            self?.stopLoadingView()
            if success {
                if isNewUser ?? true {
                    completionHandler(success, authUser, isNewUser ?? true)
                } else {
                    MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.loginSuccessfull.rawValue)
                    completionHandler(success, authUser, false)
                }
            } else if message?.isEmpty ?? true {
                self?.handleError(message: Validation.Error.genericError.rawValue, completionHandler: completionHandler)
            } else {
                self?.handleError(message: message ?? "", completionHandler: completionHandler)
            }
        }
    }
}
