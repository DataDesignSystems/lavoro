//
//  BaseModuleService.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class BaseModuleService: NSObject {
    let NS = NetworkService()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getCode(from data: Any) -> Int? {
        guard let json = data as? [String: Any], let data = json["data"] as? [String: Any] else {
            return nil
        }
        if let code = data["code"] as? Int {
            if code == 301 {
                MessageViewAlert.showError(with: Validation.Error.tokenExpire.rawValue)
                appDelegate.presentLoginFlow()
            } else {
                return code
            }
        }
        return nil
    }
    
    func getToken(from data: Any) -> String? {
        guard let json = data as? [String: Any], let data = json["data"] as? [String: Any] else {
            return nil
        }
        if let token = data["token"] as? String {
            return token
        }
        return nil
    }
    
    func getMessage(from data: Any) -> String? {
        guard let json = data as? [String: Any], let data = json["data"] as? [String: Any] else {
            return nil
        }
        if let message = data["message"] as? String {
            return message
        }
        return nil
    }
    
    @discardableResult
    func updateUser(from json: Any) -> AuthUser? {
        if let data = json as? [String: Any], let dataObj = data["data"] as? [String: Any], let profileData = dataObj["profile"]  as? [String: Any] {
            let authUser = AuthUser(json: profileData, token: self.getToken(from: json) ?? "")
            authUser.saveUser()
            return authUser
        }
        return nil
    }
}
