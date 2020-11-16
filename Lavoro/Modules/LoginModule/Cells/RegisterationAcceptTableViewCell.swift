//
//  RegisterationAcceptTableViewCell.swift
//  Lavoro
//
//  Created by Manish Agrawal on 15/11/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class RegisterationAcceptTableViewCell: UITableViewCell {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var termsNconditionsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerButton.setLayer(cornerRadius: 6)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell() {
        let fontSize: CGFloat = 15
        let color = UIColor(hexString: "#FF2D55")
        let text = NSMutableAttributedString(string: "By signing up, you agree to the ")
        text.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize), range: NSMakeRange(0, text.length))

        let selectablePart = NSMutableAttributedString(string: "Terms of Service")
        selectablePart.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize), range: NSMakeRange(0, selectablePart.length))
        
        selectablePart.addAttribute(NSAttributedString.Key.link, value: URL(string: "https://mylavoro.com/terms-and-conditions/")!, range: NSMakeRange(0,selectablePart.length))
        text.append(selectablePart)

        let and = NSMutableAttributedString(string: " and ")
        and.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize), range: NSMakeRange(0, and.length))
        text.append(and)
        
        let privacyPolicyPart = NSMutableAttributedString(string: "Privacy Policy")
        privacyPolicyPart.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize), range: NSMakeRange(0, privacyPolicyPart.length))
        
        privacyPolicyPart.addAttribute(NSAttributedString.Key.link, value: URL(string: "https://mylavoro.com/privacy-policy/")!, range: NSMakeRange(0,privacyPolicyPart.length))
        text.append(privacyPolicyPart)


        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))

        termsNconditionsTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        termsNconditionsTextView.attributedText = text
        termsNconditionsTextView.isEditable = false
        termsNconditionsTextView.isSelectable = true
        termsNconditionsTextView.delegate = self
    }
}

extension RegisterationAcceptTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
}
