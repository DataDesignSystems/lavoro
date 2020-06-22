//
//  ProfileTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.setLayer(cornerRadius: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with object: ProfileInfo) {
        if object.type == .publicProfile {
            if let authUser = AuthUser.getAuthUser(), let url = URL(string: authUser.avatar) {
                iconImageView.sd_setImage(with: url, completed: nil)
            }
        } else {
            iconImageView.image = UIImage(named: object.icon)
        }
        titleLabel.text = object.title
    }
}
