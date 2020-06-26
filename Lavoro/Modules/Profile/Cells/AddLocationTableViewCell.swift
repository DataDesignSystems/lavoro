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
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationImage.setLayer(cornerRadius: 24)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.locationImage.image = UIImage(named: "locationPlaceholder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with object: WorkLocation, indexPath: IndexPath = IndexPath(row: 0, section: 0)) {
        nameLabel.text = object.name
        addressLabel.text = object.address
        self.indexPath = indexPath
        if let photoData = object.photoData {
            GPManager.loadPlacePhoto(photoData: photoData, indexpath: indexPath) { [weak self] (image, error, index) in
                if let image = image, self?.indexPath == index {
                    self?.locationImage.image = image
                } else {
                    self?.locationImage.image = UIImage(named: "locationPlaceholder")
                }
            }
        } else {
            self.locationImage.image = UIImage(named: "locationPlaceholder")
        }
    }
}
