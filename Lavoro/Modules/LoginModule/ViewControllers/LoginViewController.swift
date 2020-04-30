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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
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
    
    @IBAction func signInButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
}
