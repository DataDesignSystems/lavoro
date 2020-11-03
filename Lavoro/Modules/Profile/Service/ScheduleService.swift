//
//  ScheduleService.swift
//  Lavoro
//
//  Created by Manish on 28/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

class ScheduleService: BaseModuleService {
    static let googleId: String = "location_id"
    static let startTime: String = "start"
    static let endTime: String = "end"
    static let message: String = "message"
    static let calendarId: String = "calendar_id"
    static let calendarIdToDelete: String = "id"
    
    func addToMyCalendar(with message: String, startTime: Date, endTime: Date, placeId: String, calendarId: String?, completionHandler: @escaping ((Bool, String?) -> ())) {
        let message = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard message.count > 0 else {
            completionHandler(false, "")
            return
        }
        var params = [ScheduleService.message: message, ScheduleService.googleId: placeId, ScheduleService.startTime: startTime.toUTCString(dateFormat: "yyyy-MM-dd HH:mm:ss"), ScheduleService.endTime: endTime.toUTCString(dateFormat: "yyyy-MM-dd HH:mm:ss")]
        if let calendarId = calendarId {
            params[ScheduleService.calendarId] = calendarId
        }

        NS.getRequest(with: .addToMyCalendar, parameters: params,  authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let response = data["response"] as? String, response == "success" {
                            completionHandler(true, self?.getMessage(from: json))
                        } else {
                            completionHandler(false, self?.getMessage(from: json))
                        }
                    } else {
                        completionHandler(false, self?.getMessage(from: json))
                    }
                } else {
                    completionHandler(false, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, "")
            }
        }
    }
    
    func getMyCalendar(with completionHandler: @escaping ((Bool, String?, [ScheduleEvent]) -> ())) {
        NS.getRequest(with: .getMyCalendar, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let calendar = data["calendar"] as? [[String: Any]] {
                            var scheduleEvents = [ScheduleEvent]()
                            for cal in calendar {
                                if let event = ScheduleEvent(with: cal) {
                                    scheduleEvents.append(event)
                                }
                            }
                            completionHandler(true, self?.getMessage(from: json), scheduleEvents)
                        } else {
                            completionHandler(false, self?.getMessage(from: json), [])
                        }
                    } else {
                        completionHandler(false, self?.getMessage(from: json), [])
                    }
                } else {
                    completionHandler(false, self?.getMessage(from: json), [])
                }
            case .failure( _):
                completionHandler(false, "", [])
            }
        }
    }
    
    func removeFromMyCalendar(with calendarId: String, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: .removeFromMyCalendar, parameters: [ScheduleService.calendarIdToDelete: calendarId],  authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let response = data["response"] as? String, response == "success" {
                            completionHandler(true, self?.getMessage(from: json))
                        } else {
                            completionHandler(false, self?.getMessage(from: json))
                        }
                    } else {
                        completionHandler(false, self?.getMessage(from: json))
                    }
                } else {
                    completionHandler(false, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, "")
            }
        }
    }

}
