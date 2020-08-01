//
//  WhoIsWorkingTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 01/08/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class WhoIsWorkingTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.setLayer(cornerRadius: 32)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with object: WhoIsWorking) {
        self.name.text = object.name
        self.profession.text = object.startTimeReadableLocal + " - " + object.endTimeReadableLocal + " / " + object.position
        if let url = URL(string: object.avatar) {
            userImage.sd_setImage(with: url, completed:  nil)
        }
        if object.locationName.isEmpty {
            self.locationName.text = "Location not available"
        } else {
            self.locationName.text = object.locationName
        }
    }

}
