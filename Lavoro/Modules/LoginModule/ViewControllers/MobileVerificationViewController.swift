//
//  MobileVerificationViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class MobileVerificationViewController: BaseViewController {
    @IBOutlet weak var resendNewCode: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hiddenTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var otp0Button: UIButton!
    @IBOutlet weak var otp1Button: UIButton!
    @IBOutlet weak var otp2Button: UIButton!
    @IBOutlet weak var otp3Button: UIButton!
    var phoneNumber: String?
    let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addkeyboardObserver()
        disableKeyboardManager()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        let prefix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "ACB1C0")]
        let suffix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "FF2D55")]
        let string = NSMutableAttributedString(string: "Didn't you received any code?\n", attributes: prefix)
        string.append(NSMutableAttributedString(string: "Resend a new code.", attributes: suffix))
        resendNewCode.titleLabel?.numberOfLines = 0
        resendNewCode.titleLabel?.textAlignment = .center
        resendNewCode.setAttributedTitle(string, for: .normal)
        hiddenTextField.becomeFirstResponder()
        otp0Button.setLayer(cornerRadius: 6)
        otp1Button.setLayer(cornerRadius: 6)
        otp2Button.setLayer(cornerRadius: 6)
        otp3Button.setLayer(cornerRadius: 6)
        resetButton(with: "")
        messageLabel.text = "We have sent you an SMS with a code to number \(phoneNumber?.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#") ?? "")\nEnter your OTP code here"
    }
    
    func resetButton(with text: String) {
        DispatchQueue.main.async {
            self.otp0Button.backgroundColor = UIColor(hexString: "F1F2F6")
            self.otp1Button.backgroundColor = UIColor(hexString: "F1F2F6")
            self.otp2Button.backgroundColor = UIColor(hexString: "F1F2F6")
            self.otp3Button.backgroundColor = UIColor(hexString: "F1F2F6")
            self.otp0Button.setTitle("", for: .normal)
            self.otp1Button.setTitle("", for: .normal)
            self.otp2Button.setTitle("", for: .normal)
            self.otp3Button.setTitle("", for: .normal)
            for (index, value) in text.enumerated() {
                switch index {
                case 0:
                    self.otp0Button.setTitle(String(value), for: .normal)
                    self.otp0Button.backgroundColor = UIColor(hexString: "FF2D55")
                case 1:
                    self.otp1Button.setTitle(String(value), for: .normal)
                    self.otp1Button.backgroundColor = UIColor(hexString: "FF2D55")
                case 2:
                    self.otp2Button.setTitle(String(value), for: .normal)
                    self.otp2Button.backgroundColor = UIColor(hexString: "FF2D55")
                case 3:
                    self.otp3Button.setTitle(String(value), for: .normal)
                    self.otp3Button.backgroundColor = UIColor(hexString: "FF2D55")
                default:
                    print("error")
                }
            }
        }
    }
    
    func setButtonBackground(_ button: UIButton) {
        if (button.titleLabel?.text?.isEmpty ?? true) || (button.titleLabel?.isHidden  ?? true) {
            button.backgroundColor = UIColor(hexString: "F1F2F6")
        } else {
            button.backgroundColor = UIColor(hexString: "FF2D55")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenTextField.becomeFirstResponder()
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
}
extension MobileVerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textAfterUpdate = text.replacingCharacters(in: range, with: string)
            if textAfterUpdate.count <= 4 {
                resetButton(with: textAfterUpdate)
                return true
            } else {
                return false
            }
        }
        return false
    }
}

extension MobileVerificationViewController {
    @IBAction func resendOTPTap() {
        self.showLoadingView()
        loginService.requestOTP(with: phoneNumber ?? "") { [weak self] (success, message) in
            self?.stopLoadingView()
            if success {
                MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.loginSuccessfull.rawValue)
            } else if message?.isEmpty ?? true {
                MessageViewAlert.showError(with: Validation.Error.genericError.rawValue)
            } else {
                MessageViewAlert.showError(with: message ?? "")
            }
        }
    }
    
    @IBAction func nextTap() {
        guard let otp = hiddenTextField.text, Validation.pin(otp) else {
            MessageViewAlert.showError(with: Validation.ValidationError.pin.rawValue)
            return
        }
        self.showLoadingView()
        loginService.validateOTP(with: otp, phone: phoneNumber ?? "") { [weak self] (success, message, isNewUser) in
            self?.stopLoadingView()
            if success {
                if isNewUser {
                    self?.performSegue(withIdentifier: "selectType", sender: self)
                } else {
                    self?.appDelegate.presentUserFLow()
                }
                MessageViewAlert.showSuccess(with: message ?? Validation.SuccessMessage.pinValidated.rawValue)
            } else if message?.isEmpty ?? true {
                MessageViewAlert.showError(with: Validation.Error.genericError.rawValue)
            } else {
                MessageViewAlert.showError(with: message ?? "")
            }
        }
    }
}
