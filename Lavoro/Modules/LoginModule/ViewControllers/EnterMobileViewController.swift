//
//  EnterMobileViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class EnterMobileViewController: BaseFacebookViewController {
    @IBOutlet weak var fbSignInButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addkeyboardObserver()
        #if targetEnvironment(simulator)
        testNumber()
        #endif
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        let prefix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "ACB1C0")]
        let suffix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "FF2D55")]
        let string = NSMutableAttributedString(string: "Or login with ", attributes: prefix)
        string.append(NSMutableAttributedString(string: "Facebook", attributes: suffix))
        fbSignInButton.setAttributedTitle(string, for: .normal)
        phoneNumberTextField.setLayer(cornerRadius: 6.0)
        phoneNumberTextField.leftPadding()
        phoneNumberTextField.becomeFirstResponder()
    }
    
    
    func testNumber() {
        self.phoneNumberTextField.text =  "9852059701"//2243238312"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumberTextField.becomeFirstResponder()
    }
    
    override func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    
        {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    override func keyboardWillHide(notification: NSNotification)
    {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            bottomConstraint.constant = 0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifyOTP" {
            if let vc = segue.destination as? MobileVerificationViewController {
                vc.phoneNumber = phoneNumberTextField.text ?? ""
            }
        }
    }
    
    @IBAction func facebookLoginTap() {
        self.facebookLogin { [weak self] (success, authUser, isNewUser) in
            if success {
                if isNewUser {
                    self?.performSegue(withIdentifier: "registerFlow", sender: self)
                } else {
                    self?.appDelegate.presentUserFLow()
                }
            }
        }
    }
    
    @IBAction func requestOTPTap() {
        if Validation.phone(phoneNumberTextField.text?.removePhoneFormating() ?? "") {
            showLoadingView()
            loginService.requestOTP(with: phoneNumberTextField.text ?? "") { [weak self] (success, message) in
                self?.stopLoadingView()
                if success {
                    self?.performSegue(withIdentifier: "verifyOTP", sender: self)
                    MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.loginSuccessfull.rawValue)
                } else if message?.isEmpty ?? true {
                    MessageViewAlert.showError(with: Validation.Error.genericError.rawValue)
                } else {
                    MessageViewAlert.showError(with: message ?? "")
                }
            }
        } else {
            MessageViewAlert.showError(with: Validation.ValidationError.phoneNo.rawValue)
        }
    }
}
extension EnterMobileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)

        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.hasPrefix("1")

        if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

            return (newLength > 10) ? false : true
        }
        var index = 0 as Int
        let formattedString = NSMutableString()

        if hasLeadingOne {
            formattedString.append("1 ")
            index += 1
        }
        if (length - index) > 3 {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("(%@)", areaCode)
            index += 3
        }
        if length - index > 3 {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }

        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        textField.text = formattedString as String
        return false
    }
}
