//
//  UIView.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setLayer(cornerRadius: CGFloat, showBorder: Bool = false ,borderWidth: CGFloat = 0.0, borderColor: UIColor = .gray) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        if showBorder {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
    func gradientLayer(with startColor: UIColor, endColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func outerShadow(shadowOpacity: Float, shadowColor: UIColor) {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = .zero//CGSize(width: 10.0, height: 8.0)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}

extension UITextField {
    func leftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}
