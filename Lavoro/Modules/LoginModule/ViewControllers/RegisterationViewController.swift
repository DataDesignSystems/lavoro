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
import SDWebImage

class RegisterationViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var user = User()
    var textFieldPlacehoders = ["Username", "Password", "Email", "Phone", "Gender", "Date of birth"]
    let loginService = LoginService()
    let imageService = ImageService()
    var isEditingProfile = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
    }
    
    func loadUserData() {
        if let authUser = AuthUser.getAuthUser() {
            user.username = authUser.username
            user.password = ""
            user.email = authUser.email
            user.phone = authUser.phone
            user.gender = authUser.gender
            user.dob = authUser.birthday
            user.imageURL = authUser.avatar
        }
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
            let phone: String? = user.phone.isEmpty ? nil : user.phone.removePhoneFormating()
            let gender: String? = user.gender.isEmpty ? nil : user.gender
            let dob: String? = user.dob.isEmpty ? nil : user.dob
            showLoadingView()
            uploadImage { [weak self] (url) in
                let imageURL: String? = (url?.isEmpty ?? true) ? nil : (url ?? nil)
                self?.loginService.updateUserProfile(with: username, password: password, email: email, phone: phone, gender: gender, dob: dob, imageURL: imageURL) { [weak self] (success, message) in
                    self?.stopLoadingView()
                    if success {
                        if self?.isEditingProfile ?? false {
                            self?.backButton()
                        } else {
                            self?.appDelegate.presentUserFLow()
                        }
                        MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.profileUpdatedSuccessfully.rawValue)
                    } else if message?.isEmpty ?? true {
                        MessageViewAlert.showError(with: Validation.Error.genericError.rawValue)
                    } else {
                        MessageViewAlert.showError(with: message ?? "")
                    }
                }
            }
        }
    }
    
    func uploadImage(completionHandler: @escaping ((String?) -> ())) {
        if let image = user.image {
            imageService.uploadImage(image) { (success, url) in
                    completionHandler(url)
            }
        } else {
            completionHandler(nil)
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
        if !Validation.phone(user.phone.removePhoneFormating()) {
            MessageViewAlert.showError(with: Validation.ValidationError.phoneNo.rawValue)
            return false
        }
        if !Validation.gender(user.gender) {
            MessageViewAlert.showError(with: Validation.ValidationError.gender.rawValue)
            return false
        }
        if !Validation.dob(user.dob) {
            MessageViewAlert.showError(with: Validation.ValidationError.dob.rawValue)
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
            } else if let url = URL(string: user.imageURL) {
                cell.imageSelectionButton.sd_setImage(with: url, for: .normal, completed: nil)
            }
            cell.imageSelectionButton.addTarget(self, action: #selector(imageSelectionButton(button:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerationTextCell", for: indexPath) as! RegisterationTextTableViewCell
            cell.textField.isSecureTextEntry = false
            cell.textField.keyboardType = .default
            var text = ""
            switch indexPath.row - 1 {
            case 0:
                text = user.username
            case 1:
                text = user.password
                cell.textField.isSecureTextEntry = true
            case 2:
                text = user.email
                cell.textField.keyboardType = .emailAddress
            case 3:
                text = user.phone
                if let authUser = AuthUser.getAuthUser(), authUser.phone.count > 8 {
                    cell.textField.isUserInteractionEnabled = false
                }
            case 4:
                text = user.gender
                cell.textField.isUserInteractionEnabled = false
            case 5:
                text = user.dob
                cell.textField.isUserInteractionEnabled = false
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
        switch indexPath.row {
        case 5:
            let alertController = UIAlertController(title: "Select Gender", message: "", preferredStyle: .actionSheet)
            let maleButton = UIAlertAction(title: "Male", style: .default, handler: { (action) -> Void in
                self.user.gender = "Male"
                tableView.reloadData()
            })
            let  femaleButton = UIAlertAction(title: "Female", style: .default, handler: { (action) -> Void in
                self.user.gender = "Female"
                tableView.reloadData()
            })

            alertController.addAction(maleButton)
            alertController.addAction(femaleButton)
            self.navigationController!.present(alertController, animated: true, completion: nil)
        case 6: //dob picker
            let selectedDate = user.dob.toDate(dateFormat: "YYYY-MM-dd") ?? Date()
            RPicker.selectDate(title: "Select Date", cancelText: "Cancel", selectedDate: selectedDate, maxDate: Date(), didSelectDate: { [weak self] (selectedDate) in
                self?.user.dob = selectedDate.toString(dateFormat: "YYYY-MM-dd")
                tableView.reloadData()
            })
        default:
            print("error")
        }
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
