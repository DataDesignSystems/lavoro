//
//  WhoIsWorking.swift
//  Lavoro
//
//  Created by Manish on 01/08/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

struct WhoIsWorking {
    var calendarId: String
    var userId: String
    var message: String
    var avatar: String
    var startUTC: String
    var endUTC: String
    var name: String
    var locationName: String
    var position: String
    var startTimeReadableLocal: String
    var endTimeReadableLocal: String
    
    init(with json: [String: Any]) {
        self.calendarId = json["calendar_id"] as? String ?? ""
        self.userId = json["user_id"] as? String ?? ""
        self.message = json["message"] as? String ?? ""
        self.avatar = json["avatar"] as? String ?? ""
        self.startUTC = json["start_utc"] as? String ?? ""
        self.endUTC = json["end_utc"] as? String ?? ""
        self.name = json["username"] as? String ?? ""
        self.locationName = json["name"] as? String ?? ""
        self.position = json["position"] as? String ?? ""
        self.startTimeReadableLocal = json["start_time_readable_local"] as? String ?? ""
        self.endTimeReadableLocal = json["end_time_readable_local"] as? String ?? ""
    }
}
