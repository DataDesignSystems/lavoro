//
//  AddScheduleType.swift
//  Lavoro
//
//  Created by Manish on 10/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation


enum AddLocationDataType: String {
    case location = "LOCATION"
    case date = "DATE"
    case startEndTime = "START/END TIME"
}

struct AddScheduleType {
    var type: AddLocationDataType
    var value: String
}
