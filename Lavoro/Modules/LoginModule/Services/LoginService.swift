//
//  LoginService.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class LoginService: BaseModuleService {
    static let email: String = "email"
    static let password: String = "password"
    static let phone: String = "phone"
    static let pin: String = "pin"
    static let firstName: String = "first"
    static let lastName: String = "last"
    static let facebookToken: String = "facebookToken"
    static let userTypeId: String = "userTypeId"
    static let username: String = "username"
    static let gender: String = "gender"
    static let dob: String = "dob"
    static let avatar: String = "avatar"
    
    func login(with email: String, password: String, completionHandler: @escaping ((Bool, User?, String?) -> ())) {
        NS.getRequest(with: .login, parameters: [LoginService.email: email, LoginService.password: password]) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    completionHandler(true, User(), self?.getMessage(from: json))
                } else {
                    completionHandler(false, nil, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, nil, "")
            }
        }
    }

    func requestOTP(with phoneNumber: String, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: .pinRequest, parameters: [LoginService.phone: phoneNumber]) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    completionHandler(true, self?.getMessage(from: json))
                } else {
                    completionHandler(false, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, "")
            }
        }
    }
    
    func validateOTP(with pin: String, phone: String, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: .pinValidation, parameters: [LoginService.pin: pin, LoginService.phone: phone]) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    self?.updateUser(from: json)
                    completionHandler(true, self?.getMessage(from: json))
                } else {
                    completionHandler(false, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, "")
            }
        }
    }
    //(success, message, auth user, is new user)
    func facebookAuthenticate(with user: FBUser, completionHandler: @escaping ((Bool, String?, AuthUser?, Bool?) -> ())) {
        let params = [LoginService.firstName:user.firstName, LoginService.lastName:user.lastName, LoginService.email:user.email, LoginService.facebookToken:user.token].compactMapValues({ $0 })
        NS.getRequest(with: .facebookAuthentication, parameters: params) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let data = json as? [String: Any], let dataObj = data["data"] as? [String: Any], let profileData = dataObj["profile"]  as? [String: Any] {
                        let isNewUser = !(profileData["didRegister"] as? Bool ?? false)
                        let authUser = AuthUser(json: profileData, token: self?.getToken(from: json) ?? "")
                        authUser.saveUser()
                        completionHandler(true, self?.getMessage(from: json), authUser, isNewUser)
                    } else {
                        completionHandler(false, self?.getMessage(from: json), nil, nil)
                    }
                } else {
                    completionHandler(false, self?.getMessage(from: json), nil, nil)
                }
            case .failure( _):
                completionHandler(false, "", nil, nil)
            }
        }
    }

    func updateUserAccountType(with typeId: String, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: .updateUserAccountType, parameters: [LoginService.userTypeId: typeId], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    self?.updateUser(from: json)
                    completionHandler(true, self?.getMessage(from: json))
                } else {
                    completionHandler(false, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, "")
            }
        }
    }
    
    func updateUserProfile(with username: String?, password: String?, email: String?, phone: String?, gender: String?, dob: String?, imageURL: String?, completionHandler: @escaping ((Bool, String?) -> ())) {
        let params = [LoginService.username: username, LoginService.email: email, LoginService.password:password, LoginService.phone: phone, LoginService.gender: gender, LoginService.dob: dob, LoginService.avatar: imageURL].compactMapValues({ $0 })
        NS.getRequest(with: .updateUserProfile, parameters: params, authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    self?.updateUser(from: json)
                    completionHandler(true, self?.getMessage(from: json))
                } else {
                    completionHandler(false, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, "")
            }
        }
    }
}
