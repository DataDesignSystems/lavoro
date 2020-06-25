//
//  AddLocationTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 10/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import GooglePlaces

class AddLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var nameCenterYConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationImage.setLayer(cornerRadius: 24)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with object: WorkLocation) {
        nameLabel.text = object.name
        addressLabel.text = object.address
        locationImage.image = UIImage(named: "locationPlaceholder")
        if let photoData = object.photoData {
            GMSPlacesClient.shared().loadPlacePhoto(photoData) { [weak self] (image, error) in
                if let image = image {
                    self?.locationImage.image = image
                }
            }
        }
    }
}
