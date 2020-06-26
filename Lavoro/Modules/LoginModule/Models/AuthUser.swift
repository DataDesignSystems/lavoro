//
//  Authuser.swift
//  Lavoro
//
//  Created by Manish on 08/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

enum UserType: String{
    case admin = "1"
    case customer = "2"
    case serviceProvider = "3"
}

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
    let gender: String
    let birthday: String
    let username: String
    let avatar: String
    let type: UserType
    var checkStatus: String
    var placeId: String
    var placeName: String
    let didRegister: Bool

    private static var authUser: AuthUser?
    
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
         authToken: String,
         gender: String,
         birthday: String,
         username: String,
         avatar: String,
         checkStatus: String,
         placeId: String,
         placeName: String,
         didRegister: Bool) {
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
        self.gender = gender
        self.birthday = birthday
        self.username = username
        self.avatar = avatar
        self.type = UserType(rawValue: userTypeId) ?? .customer
        self.checkStatus = checkStatus
        self.placeId = placeId
        self.placeName = placeName
        self.didRegister = didRegister
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
        self.gender = json["gender"] as? String ?? ""
        self.birthday = json["birthday"] as? String ?? ""
        self.username =  json["username"] as? String ?? ""
        self.avatar = json["avatar"] as? String ?? ""
        self.type = UserType(rawValue: json["userTypeId"] as? String ?? "") ?? .customer
        if let checkStatus = json["check_status"] as? [String: Any] {
            self.checkStatus = checkStatus["type"] as? String ?? "check-out"
            self.placeId = checkStatus["google_id"] as? String ?? ""
            self.placeName = checkStatus["name"] as? String ?? ""
        } else {
            self.checkStatus = "check-out"
            self.placeId = ""
            self.placeName = ""
        }
        self.didRegister = json["didRegister"] as? Bool ?? false
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
        let gender = aDecoder.decodeObject(forKey: "gender") as? String ?? ""
        let birthday = aDecoder.decodeObject(forKey: "birthday") as? String ?? ""
        let username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        let avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        let checkStatus = aDecoder.decodeObject(forKey: "checkStatus") as? String ?? ""
        let placeId = aDecoder.decodeObject(forKey: "placeId") as? String ?? ""
        let placeName = aDecoder.decodeObject(forKey: "placeName") as? String ?? ""
        let didRegister = aDecoder.decodeBool(forKey: "didRegister") as? Bool ?? false
        self.init(id: id, first: first, middle: middle, last: last, phone: phone, email: email, facebookToken: facebookToken, userTypeId: userTypeId, status: status, userType: userType, authToken: authToken, gender: gender, birthday: birthday, username: username, avatar: avatar, checkStatus: checkStatus, placeId: placeId, placeName: placeName, didRegister: didRegister)
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
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(checkStatus, forKey: "checkStatus")
        aCoder.encode(placeId, forKey: "placeId")
        aCoder.encode(placeName, forKey: "placeName")
        aCoder.encode(didRegister, forKey: "didRegister")
    }

    
    func saveUser() {
        do {
            let userDefaults = UserDefaults.standard
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "authuser")
            userDefaults.synchronize()
            AuthUser.authUser = AuthUser.loadAuthUser()
            LoginChatUser.registerUserForChat()
        }
        catch {
            print("ERROR")
        }
    }
    
    @discardableResult
    static func loadAuthUser() -> AuthUser? {
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.data(forKey: "authuser") {
            do {
                let authUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? AuthUser
                return authUser
            }
            catch {
                print("Error")
            }
        }
        return nil
    }
    
    static func logout() {
        ALChatManager(applicationKey: ALChatManager.applicationId).logoutUser { (success) in
            print("###ALChatManager Logout \(success)")
        }
        AuthUser.authUser = nil
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "authuser")
        userDefaults.synchronize()
    }
    
    func toggleCheckInStatus(with placeName: String, placeId: String) {
        if self.checkStatus == "check-out"{
            self.checkStatus = "check-in"
        } else {
            self.checkStatus = "check-out"
        }
        self.placeName = placeName
        self.placeId = placeId
        saveUser()
    }
    
    func isAlreadyCheckIn() -> Bool {
        if self.checkStatus == "check-in" {
            return true
        }
        return false
    }
}
