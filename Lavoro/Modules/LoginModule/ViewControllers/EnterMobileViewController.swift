//
//  EnterMobileViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class EnterMobileViewController: BaseViewController {
    @IBOutlet weak var fbSignInButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addkeyboardObserver()
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
}
