//
//  LoginViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        testUser()
    }
    
    func setupView() {
        formView.setLayer(cornerRadius: 16.0)
        let prefix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "B8BBC6")]
        let suffix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "FF2D55")]
        let string = NSMutableAttributedString(string: "Don't have an account? ", attributes: prefix)
        string.append(NSMutableAttributedString(string: "Sign Up", attributes: suffix))
        signUpButton.setAttributedTitle(string, for: .normal)
        signInButton.setLayer(cornerRadius: 6.0)
        emailTextField.setLayer(cornerRadius: 6.0)
        passwordtextField.setLayer(cornerRadius: 6.0)
        emailTextField.leftPadding()
        passwordtextField.leftPadding()
    }
    
    func testUser() {
        emailTextField.text = "brad@datadesignsystems.com"
        passwordtextField.text = "GoJackets2018!"
    }
    
    @IBAction func signInButtonTap() {
        if Validation.email(emailTextField.text ?? "") {
            if Validation.password(passwordtextField.text ?? "") {
                showLoadingView()
                loginService.login(with: emailTextField.text ?? "", password: passwordtextField.text ?? "") { [weak self] (success, user, message) in
                    self?.stopLoadingView()
                    if success {
                        self?.appDelegate.presentUserFLow()
                        MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.loginSuccessfull.rawValue)
                    } else if message?.isEmpty ?? true {
                        MessageViewAlert.showError(with: Validation.Error.loginError.rawValue)
                    } else {
                        MessageViewAlert.showError(with: message ?? "")
                    }
                }
            } else {
                MessageViewAlert.showError(with: Validation.ValidationError.password.rawValue)
            }
        } else {
            MessageViewAlert.showError(with: Validation.ValidationError.email.rawValue)
        }
    }
}
