//
//  AccountTypeTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class AccountTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var backimageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var parentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        parentView.setLayer(cornerRadius: 16)
        continueButton.setLayer(cornerRadius: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(with object: AccountType) {
        backimageView.image = UIImage(named: object.imageName)
        titleLabel.text = object.title
    }
}
