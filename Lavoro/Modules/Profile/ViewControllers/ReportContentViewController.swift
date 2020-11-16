//
//  UpdateTaglineViewController.swift
//  Lavoro
//
//  Created by Manish on 20/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class ReportContentViewController: BaseViewController {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var charLimitLabel: UILabel!
    var reportButtonTitle: String?
    let placeholderText = "Help us to understand the problem..." 
    let profileService = ProfileService()
    var onComplete: ((_ result: String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        parentView.setLayer(cornerRadius: 8)
        reportButton.setLayer(cornerRadius: 4)
        message.text = placeholderText
        charLimitLabel.text = "0/\(AppPrefrences.messageCharLimit)"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.addGestureRecognizer(tapGesture)
        if let reportButtonTitle = reportButtonTitle {
            reportButton.setTitle(reportButtonTitle, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        message.becomeFirstResponder()
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInNotify() {
        onComplete?(message.text)
        closeButtonAction()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ReportContentViewController: UITextViewDelegate {
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
