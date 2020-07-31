//
//  UpdateTaglineViewController.swift
//  Lavoro
//
//  Created by Manish on 20/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

protocol TaglineUpdatedDelegate {
    func taglineUpdated(_ tagline: String)
}

class UpdateTaglineViewController: BaseViewController {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var charLimitLabel: UILabel!
    let placeholderText = "Say something..." 
    let profileService = ProfileService()
    var lastTagline = ""
    var delegate: TaglineUpdatedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        parentView.setLayer(cornerRadius: 8)
        userImage.setLayer(cornerRadius: 4)
        checkInButton.setLayer(cornerRadius: 4)
        if let url = URL(string: AuthUser.getAuthUser()?.avatar ?? "") {
            userImage.sd_setImage(with: url, completed: nil)
        }
        if !lastTagline.isEmpty {
            message.text = lastTagline
            charLimitLabel.text = "\(lastTagline.count)/\(AppPrefrences.messageCharLimit)"
        } else {
            message.text = placeholderText
            charLimitLabel.text = "0/\(AppPrefrences.messageCharLimit)"
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInNotify() {
        self.updateTagline()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateTagline() {
        let tagline = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard tagline.count > 0 else {
            return
        }
        self.showLoadingView()
        profileService.updateTagline(with: tagline) { [weak self] (success, message) in
            self?.stopLoadingView()
            if success {
                self?.delegate?.taglineUpdated(tagline)
                self?.closeButtonAction()
            } else {
                MessageViewAlert.showError(with: message ?? "There is some error./nPlease try again")
            }
        }
    }
}

extension UpdateTaglineViewController: UITextViewDelegate {
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
