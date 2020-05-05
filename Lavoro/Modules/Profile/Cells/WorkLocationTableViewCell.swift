//
//  WorkLocationTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 05/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class WorkLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workingStatusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        locationImage.setLayer(cornerRadius: 8)
        // Configure the view for the selected state
    }

    func setupCell(with object: WorkLocation) {
        nameLabel.text = object.name
        addressLabel.text = object.address
        workingStatusLabel.text = object.workingType.rawValue
        locationLabel.text = "\(object.distance) mi"
        locationImage.image = UIImage(named: object.imageName)
        switch object.workingType {
        case .working:
            workingStatusLabel.textColor = UIColor(hexString: "4CD964")
        case .notWorking:
            workingStatusLabel.textColor = UIColor(hexString: "FF2D55")
        }
    }
}
