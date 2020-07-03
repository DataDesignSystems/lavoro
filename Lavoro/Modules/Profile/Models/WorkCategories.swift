//
//  WorkCategories.swift
//  Lavoro
//
//  Created by Manish on 05/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

struct WorkCategory {
    var category: String
}

enum CategoryType: String {
    case all = "All"
    case restaurants = "Restaurants"
    case bars = "Bars"
    case hotels = "Hotels"
    case other = "Other"
}
