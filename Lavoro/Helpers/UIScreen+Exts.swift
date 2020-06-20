//
//  UIScreen+Exts.swift
//  Lavoro
//
//  Created by Manish on 19/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    func safeAreaTop() -> CGFloat {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return window?.safeAreaInsets.top ?? 0
    }
}
