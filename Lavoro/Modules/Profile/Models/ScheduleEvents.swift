//
//  ScheduleEvents.swift
//  Lavoro
//
//  Created by Manish on 28/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import KVKCalendar

struct ScheduleEvent {
    let calendarId: String
    let googleId: String
    let message: String
    let startTime: Date
    let endTime: Date
    let locationText: String
    
    init?(with json: [String: Any]) {
        self.calendarId = json["calendar_id"] as? String ?? ""
        self.googleId = json["google_id"] as? String ?? ""
        self.message = json["message"] as? String ?? ""
        if let startUTC = json["start_utc"] as? String, let startDate = startUTC.toDateFromUTC(dateFormat: "yyyy-MM-dd HH:mm:ss") {
            self.startTime = startDate
        } else {
            return nil
        }
        if let endUTC = json["end_utc"] as? String, let endDate = endUTC.toDateFromUTC(dateFormat: "yyyy-MM-dd HH:mm:ss") {
            self.endTime = endDate
        } else {
            return nil
        }
        self.locationText = json["location"] as? String ?? ""
    }
}

