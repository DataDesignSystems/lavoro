//
//  FollowTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 06/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.setLayer(cornerRadius: 30)
        followButton.setLayer(cornerRadius: 4, showBorder: true, borderWidth: 1, borderColor: UIColor(hexString: "FF2D55"))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(with object: OtherUser) {
        name.text = object.name
        profession.text = ""
        if let url = URL(string: object.avatar) {
            userImage.sd_setImage(with: url, completed:  nil)
        }
    }

}
