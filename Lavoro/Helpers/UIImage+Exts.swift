//
//  UIImage+Exts.swift
//  Lavoro
//
//  Created by Manish on 12/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
