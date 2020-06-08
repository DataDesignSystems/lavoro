//
//  Authuser.swift
//  Lavoro
//
//  Created by Manish on 08/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
class AuthUser {
    let id: String
    let first: String
    let middle: String
    let last: String
    let phone: String
    let email: String
    let facebookToken: String
    let userTypeId: String
    let status: String
    let userType: String
    
    init(id: String,
         first: String,
         middle: String,
         last: String,
         phone: String,
         email: String,
         facebookToken: String,
         userTypeId: String,
         status: String,
         userType: String) {
        self.id = id
        self.first = first
        self.middle = middle
        self.last = last
        self.phone = phone
        self.email = email
        self.facebookToken = facebookToken
        self.userTypeId = userTypeId
        self.status = status
        self.userType = userType
    }
    
    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.first = json["first"] as? String ?? ""
        self.middle = json["middle"] as? String ?? ""
        self.last = json["last"] as? String ?? ""
        self.phone = json["phone"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.facebookToken = json["facebookToken"] as? String ?? ""
        self.userTypeId = json["userTypeId"] as? String ?? ""
        self.status = json["status"] as? String ?? ""
        self.userType = json["userType"] as? String ?? ""
    }
}
