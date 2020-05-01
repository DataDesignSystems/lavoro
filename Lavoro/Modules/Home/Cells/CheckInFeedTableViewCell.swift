//
//  CheckInFeedTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 01/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class CheckInFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var checkInImage: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var locationNameBackgroundView: UIView!
    @IBOutlet weak var locationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.setLayer(cornerRadius: 8)
        userImage.setLayer(cornerRadius: 25)
        checkInImage.setLayer(cornerRadius: 4)
        locationNameBackgroundView.setLayer(cornerRadius: 4)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likesButtonTap(button: UIButton) {
        
    }
    
    @IBAction func commentsButtonTap(button: UIButton) {
        
    }
}
