//
//  MobileVerificationViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class MobileVerificationViewController: BaseViewController {
    @IBOutlet weak var fbSignInButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hiddenTextField: UITextField!
    @IBOutlet weak var otp0Button: UIButton!
    @IBOutlet weak var otp1Button: UIButton!
    @IBOutlet weak var otp2Button: UIButton!
    @IBOutlet weak var otp3Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addkeyboardObserver()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        let prefix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "ACB1C0")]
        let suffix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "FF2D55")]
        let string = NSMutableAttributedString(string: "Didn't you received any code?\n", attributes: prefix)
        string.append(NSMutableAttributedString(string: "Resend a new code.", attributes: suffix))
        fbSignInButton.titleLabel?.numberOfLines = 0
        fbSignInButton.titleLabel?.textAlignment = .center
        fbSignInButton.setAttributedTitle(string, for: .normal)
        hiddenTextField.becomeFirstResponder()
        otp0Button.setLayer(cornerRadius: 6)
        otp1Button.setLayer(cornerRadius: 6)
        otp2Button.setLayer(cornerRadius: 6)
        otp3Button.setLayer(cornerRadius: 6)
        resetButton(with: "")
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
