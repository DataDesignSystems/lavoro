//
//  SendGroupMessageViewController.swift
//  Lavoro
//
//  Created by Manish on 04/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class SendGroupMessageViewController: BaseViewController {
    @IBOutlet weak var gradientTopView: UIView!
    @IBOutlet weak var gradientBottomView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var charLimitLabel: UILabel!
    let profileService = ProfileService()
    let placeholderText = "Say something..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        gradientTopView.gradientLayer(with: UIColor(white: 0, alpha: 0.75), endColor: UIColor(white: 0, alpha: 0))
        gradientBottomView.gradientLayer(with: UIColor(white: 0, alpha: 0), endColor: UIColor(white: 0, alpha: 1))
        parentView.setLayer(cornerRadius: 8)
        userImage.setLayer(cornerRadius: 4)
        checkInButton.setLayer(cornerRadius: 4)
        if let url = URL(string: AuthUser.getAuthUser()?.avatar ?? "") {
            userImage.sd_setImage(with: url, completed: nil)
        }
        checkInButton.backgroundColor = UIColor(hexString: "#FF2D55")
        charLimitLabel.text = "0/\(AppPrefrences.messageCharLimit)"
    }
    
    @IBAction func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInNotify() {
        let messageToSend = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard messageToSend.count > 0 else {
            return
        }
        self.showLoadingView()
        userService.sendGroupMessage(with: messageToSend) { [weak self] (success, message) in
            self?.stopLoadingView()
            if success {
                if let message = message {
                    MessageViewAlert.showSuccess(with: message)
                }
                self?.closeButtonAction()
            } else {
                MessageViewAlert.showError(with: message ?? "There is some error./nPlease try again")
            }
        }
    }
}

extension SendGroupMessageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        if let textViewString = textView.text, let swtRange = Range(range, in: textViewString) {
            let fullString = textViewString.replacingCharacters(in: swtRange, with: text)
            if fullString.count <= AppPrefrences.messageCharLimit {
                charLimitLabel.text = "\(fullString.count)/\(AppPrefrences.messageCharLimit)"
                return true
            } else {
                textView.text = fullString[0..<AppPrefrences.messageCharLimit]
                charLimitLabel.text = "\(AppPrefrences.messageCharLimit)/\(AppPrefrences.messageCharLimit)"
                return false
            }
            
        }

        return true
    }
}
