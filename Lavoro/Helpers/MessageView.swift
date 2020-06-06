//
//  MessageView.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import SwiftMessages

struct MessageViewAlert {
    static func showError(with message: String) {
        let error = MessageView.viewFromNib(layout: .cardView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: message)
        error.button?.isHidden = true
        SwiftMessages.show(view: error)
    }
    
    static func showSuccess(with message: String) {
        let error = MessageView.viewFromNib(layout: .cardView)
        error.configureTheme(.success)
        error.configureContent(title: "Success", body: message)
        error.button?.isHidden = true
        SwiftMessages.show(view: error)
    }
}
