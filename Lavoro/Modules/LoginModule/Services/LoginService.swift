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
        NS.getRequest(with: .pinRequest, parameters: [LoginService.pin: pin, LoginService.phone: phone]) { [weak self] (response) in
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
}
