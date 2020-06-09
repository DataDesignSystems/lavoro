//
//  RegisterationTextTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol RegistrationDelegate: class {
    func textEntered(with text: String, index: Int)
}

class RegisterationTextTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    weak var delegate: RegistrationDelegate?
    var index: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.titleFormatter = { $0 }
        textField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with text: String, index: Int) {
        textField.text = text
        self.index = index
    }
}
extension RegisterationTextTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textEntered(with: textField.text ?? "", index: index)
    }
}
