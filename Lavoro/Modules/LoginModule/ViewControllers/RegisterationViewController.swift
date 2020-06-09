//
//  RegisterationViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class RegisterationViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var user = User()
    var textFieldPlacehoders = ["Username", "Password", "Email", "Phone", "Gender", "Date of birth"]
    let loginService = LoginService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func imageSelectionButton(button: UIButton) {
        self.openImagePicker()
    }
    
    override func imageSelectedFromPicker(image: UIImage) {
        user.image = image
        tableView.reloadData()
    }
    
    @IBAction func saveButtonAction() {
        self.view.endEditing(true)
        if isValid() {
            let username: String? = user.username.isEmpty ? nil : user.username
            let email: String? = user.email.isEmpty ? nil : user.email
            let password: String? = user.password.isEmpty ? nil : user.password
            let phone: String? = user.phone.isEmpty ? nil : user.phone
            showLoadingView()
            loginService.updateUserProfile(with: username, password: password, email: email, phone: phone, gender: nil, dob: nil, imageURL: nil) { [weak self] (success, message) in
                self?.stopLoadingView()
                if success {
                    self?.appDelegate.presentUserFLow()
                    MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.profileUpdatedSuccessfully.rawValue)
                } else if message?.isEmpty ?? true {
                    MessageViewAlert.showError(with: Validation.Error.genericError.rawValue)
                } else {
                    MessageViewAlert.showError(with: message ?? "")
                }
            }
        }
    }
    
    func isValid() -> Bool {
        if !Validation.username(user.username) {
            MessageViewAlert.showError(with: Validation.ValidationError.username.rawValue)
            return false
        }
        if !Validation.password(user.password) {
            MessageViewAlert.showError(with: Validation.ValidationError.password.rawValue)
            return false
        }
        if !Validation.email(user.email) {
            MessageViewAlert.showError(with: Validation.ValidationError.email.rawValue)
            return false
        }
        if !Validation.phone(user.phone) {
            MessageViewAlert.showError(with: Validation.ValidationError.phoneNo.rawValue)
            return false
        }
        return true
    }
}
extension RegisterationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + textFieldPlacehoders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerationImageCell", for: indexPath) as! RegisterationImageTableViewCell
            if let image = user.image {
                cell.imageSelectionButton.setBackgroundImage(image, for: .normal)
                cell.imageSelectionButton.setImage(nil, for: .normal)
            }
            cell.imageSelectionButton.addTarget(self, action: #selector(imageSelectionButton(button:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerationTextCell", for: indexPath) as! RegisterationTextTableViewCell
            var text = ""
            switch indexPath.row - 1 {
            case 0:
                text = user.username
            case 1:
                text = user.password
            case 2:
                text = user.email
            case 3:
                text = user.phone
            case 4:
                text = user.gender
            case 5:
                text = user.dob
            default:
                print("error")
            }
            cell.textField.placeholder = textFieldPlacehoders[indexPath.row - 1]
            cell.delegate = self
            cell.setupCell(with: text, index: indexPath.row - 1)
            return cell
        }
    }
}
extension RegisterationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 260
        }
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension RegisterationViewController: RegistrationDelegate {
    func textEntered(with text: String, index: Int) {
        switch index {
        case 0:
            user.username = text
        case 1:
            user.password = text
        case 2:
            user.email = text
        case 3:
            user.phone = text
        case 4:
            user.gender = text
        case 5:
            user.dob = text
        default:
            print("error")
        }
    }
}
