//
//  UIButton+Exts.swift
//  Lavoro
//
//  Created by Manish on 09/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    override open var intrinsicContentSize: CGSize {
        let intrinsicContentSize = super.intrinsicContentSize

        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom

        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
}
