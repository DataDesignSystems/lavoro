//
//  RecommendedCollectionViewCell.swift
//  Lavoro
//
//  Created by Manish on 09/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.setLayer(cornerRadius: 30)
        followButton.setLayer(cornerRadius: 4, showBorder: true, borderWidth: 1, borderColor: UIColor(hexString: "FF2D55"))
        parentView.setLayer(cornerRadius: 12, showBorder: true, borderWidth: 1, borderColor: UIColor(hexString: "F1F2F6"))
    }
    
    func setupCell(with object: OtherUser) {
        name.text = object.name
        profession.text = object.profession
        userImage.image = UIImage(named: object.imageName)
    }
    
}
