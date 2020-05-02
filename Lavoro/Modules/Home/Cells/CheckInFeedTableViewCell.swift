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
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.setLayer(cornerRadius: 8)
        userImage.setLayer(cornerRadius: 25)
        checkInImage.setLayer(cornerRadius: 4)
        locationNameBackgroundView.setLayer(cornerRadius: 4)
        parentView.outerShadow(shadowOpacity: 0.1, shadowColor: .black)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with object: Feed) {
        username.text = object.username
        time.text = object.dateInString
        likesCount.text = "\(object.likesCount)"
        commentsCount.text = "\(object.commentsCount)"
        locationName.text = object.locationName
        var userMessage = ""
        switch object.feedType {
        case .checkIn:
            userMessage = "Checked in at\n"
            locationNameBackgroundView.backgroundColor = UIColor(hexString: "4CD964")
        case .checkOut:
            userMessage = "Checked Out of\n"
            locationNameBackgroundView.backgroundColor = UIColor(hexString: "FF2D55")
        }
        message.text = userMessage + object.message
    }

    @IBAction func likesButtonTap(button: UIButton) {
        button.isSelected = !button.isSelected
    }
    
    @IBAction func commentsButtonTap(button: UIButton) {
        
    }
}
