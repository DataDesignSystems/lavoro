//
//  Validation.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
struct Validation {
    enum ValidationError: String {
        case email = "Please enter correct email!"
        case password = "Password should be atleast 6 digit!"
        case phoneNo = "Enter phone number is not correct!"
        case pin = "Pin should be atleast 4 characters!"
        case username = "username is mandatory!"
        case gender = "Please select gender!"
        case dob = "Please select dob!"
    }
    
    enum Error: String {
        case loginError = "Your email and password does not match!"
        case genericError = "Please try again!"
    }
    
    enum SuccessMessage: String {
        case loginSuccessfull = "Logged in successfully!"
        case profileUpdatedSuccessfully = "Profile updated successfully!"
        case pinValidated = "pin validated!"
    }
    
    static func email(_ email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailValid = emailPred.evaluate(with: email)
        return emailValid
    }

    static func password(_ password: String) -> Bool{
        let passwordValid = password.count >= 6
        return passwordValid
    }
    
    static func phone(_ phone: String) -> Bool{
        let passwordValid = (phone.count == 10)
        return passwordValid
    }
    
    static func pin(_ pin: String) -> Bool{
        let pinValid = (pin.count == 4)
        return pinValid
    }
    
    static func username(_ username: String) -> Bool{
        let usernameValid = (username.count > 0)
        return usernameValid
    }
    
    static func gender(_ gender: String) -> Bool{
        let genderValid = (gender == "Male" || gender == "Female")
        return genderValid
    }
    
    static func dob(_ dob: String) -> Bool {
        if dob.toDate(dateFormat: "YYYY-MM-dd") != nil {
            return true
        }
        return false
    }
}
