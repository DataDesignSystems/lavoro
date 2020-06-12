//
//  UIDate+Exts.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(dateFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:self)

    }
}
