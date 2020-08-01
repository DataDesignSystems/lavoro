//
//  WhoIsWorkingService.swift
//  Lavoro
//
//  Created by Manish on 01/08/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
class WhoIsWorkingService: BaseModuleService {
    static let date: String = "date"

    func getWhosWorkingListByDate(with date: Date, completionHandler: @escaping ((Bool, String?, [WhoIsWorking]) -> ())) {
        NS.getRequest(with: .getWhosWorkingListByDate, parameters: [WhoIsWorkingService.date: date.toString(dateFormat: "yyyy-MM-dd")], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let list = data["list"] as? [[String: Any]] {
                            var array = [WhoIsWorking]()
                            for obj in list {
                                array.append(WhoIsWorking(with: obj))
                            }
                            completionHandler(true, self?.getMessage(from: json), array)
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
}
