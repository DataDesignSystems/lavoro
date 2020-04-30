//
//  RegisterationTextTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterationTextTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: SkyFloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.titleFormatter = { $0 }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
