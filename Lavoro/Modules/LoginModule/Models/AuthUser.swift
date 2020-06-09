//
//  Authuser.swift
//  Lavoro
//
//  Created by Manish on 08/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
class AuthUser: NSObject, NSCoding {
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
    let authToken: String
    static var authUser: AuthUser?
    
    static func getAuthUser() -> AuthUser? {
        if AuthUser.authUser == nil {
           AuthUser.authUser = loadAuthUser()
        }
        return AuthUser.authUser
    }
    
    init(id: String,
         first: String,
         middle: String,
         last: String,
         phone: String,
         email: String,
         facebookToken: String,
         userTypeId: String,
         status: String,
         userType: String,
         authToken: String) {
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
        self.authToken = authToken
    }
    
    init(json: [String: Any], token: String) {
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
        self.authToken = token
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        let first = aDecoder.decodeObject(forKey: "first") as? String ?? ""
        let middle = aDecoder.decodeObject(forKey: "middle") as? String ?? ""
        let last = aDecoder.decodeObject(forKey: "last") as? String ?? ""
        let phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        let email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        let facebookToken = aDecoder.decodeObject(forKey: "facebookToken") as? String ?? ""
        let userTypeId = aDecoder.decodeObject(forKey: "userTypeId") as? String ?? ""
        let status = aDecoder.decodeObject(forKey: "status") as? String ?? ""
        let userType = aDecoder.decodeObject(forKey: "userType") as? String ?? ""
        let authToken = aDecoder.decodeObject(forKey: "authToken") as? String ?? ""
        self.init(id: id, first: first, middle: middle, last: last, phone: phone, email: email, facebookToken: facebookToken, userTypeId: userTypeId, status: status, userType: userType, authToken: authToken)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(first, forKey: "first")
        aCoder.encode(middle, forKey: "middle")
        aCoder.encode(last, forKey: "last")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(facebookToken, forKey: "facebookToken")
        aCoder.encode(userTypeId, forKey: "userTypeId")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(userType, forKey: "userType")
        aCoder.encode(authToken, forKey: "authToken")
    }

    
    func saveUser() {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        userDefaults.set(encodedData, forKey: "authuser")
        userDefaults.synchronize()
        AuthUser.authUser = nil
    }
    
    static func loadAuthUser() -> AuthUser? {
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.data(forKey: "authuser") {
            return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? AuthUser
        }
        return nil
    }
}
