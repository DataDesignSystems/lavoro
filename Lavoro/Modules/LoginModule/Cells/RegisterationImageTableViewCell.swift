//
//  RegisterationImageTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class RegisterationImageTableViewCell: UITableViewCell {
    @IBOutlet weak var imageSelectionButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageSelectionButton.setLayer(cornerRadius: 16)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
