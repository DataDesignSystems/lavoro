//
//  OnboardingCollectionViewCell.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupCell(with object: OnboardingInfo) {
        self.imageView.image = UIImage(named: object.imagename)
        self.titleLabel.text = object.title
    }
}
