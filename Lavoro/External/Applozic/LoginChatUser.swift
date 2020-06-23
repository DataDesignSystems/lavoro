//
//  LoginChatUser.swift
//  Lavoro
//
//  Created by Manish on 14/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import ApplozicSwift
import Applozic

class LoginChatUser {
    static func registerUserForChat() {
        if let authUser = AuthUser.getAuthUser() {
            let alUser : ALUser =  ALUser()
            alUser.applicationId = ALChatManager.applicationId
            alUser.userId = authUser.id
            alUser.email = authUser.email
            alUser.imageLink = authUser.avatar
            alUser.displayName = authUser.username // "\(authUser.first) \(authUser.last)"
            alUser.password = "Atustr29!"


            //Saving these details
            ALUserDefaultsHandler.setUserId(alUser.userId)
            ALUserDefaultsHandler.setEmailId(alUser.email)
            ALUserDefaultsHandler.setDisplayName(alUser.displayName)


            //Registering or Login in the User
            let chatManager = ALChatManager(applicationKey: ALChatManager.applicationId)
            chatManager.connectUser(alUser, completion: {response, error in
                        if error == nil {
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                appDelegate.updateBadgeCountForUnreadMessage()
                            }
                            print("###ALChatManager Successfull login")
                        } else {
                            print("Cannot create a new account on Applozic with userID: \(authUser.id), email: \(authUser.email)")
                        }
                    })
        } else {
            print("user not logged in")
        }
    }
}
