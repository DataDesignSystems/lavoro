//
//  WorkCategoriesCollectionViewCell.swift
//  Lavoro
//
//  Created by Manish on 05/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class WorkCategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    let selectedColor = UIColor(hexString: "1E2432")
    let unselectedColor = UIColor(hexString: "ACB1C0")
    
    func setupCell(with object: WorkCategories, selectedCategory: WorkCategories) {
        if object.category == selectedCategory.category {
            categoryName.textColor = selectedColor
        } else {
            categoryName.textColor = unselectedColor
        }
        categoryName.text = object.category.rawValue
    }
}
