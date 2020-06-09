//
//  NetworkConfig.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

struct NetworkConfig {
    static let baseURL: String = "https://api.lavoro.network/"
    
    enum Endpoint: String{
        case login = "api/login/0/"
        case pinRequest = "api/send-pin-request/0/"
        case pinValidation = "api/validate-pin-request/0/"
        case facebookAuthentication = "api/facebook-login/0/"
        case updateUserAccountType = "api/update-user-account-type/"
        case updateUserProfile = "api/update-user-profile/"
    }
}
