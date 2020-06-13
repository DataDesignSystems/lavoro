//
//  HomeService.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class HomeService: BaseModuleService {
    
    
    func getDashboardData(with completionHandler: @escaping ((Bool, String?, [Feed]) -> ())) {
        NS.getRequest(with: .dashboard, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    var feeds = [Feed]()
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any], let dashboard =  data["dashboard"] as? [String: Any], let feedJson = dashboard["feed"] as? [[String: Any]] {
                        for feed in feedJson {
                            feeds.append(Feed(with: feed))
                        }
                    }
                    completionHandler(true, self?.getMessage(from: json), feeds)
                } else {
                    completionHandler(false, self?.getMessage(from: json), [])
                }
            case .failure( _):
                completionHandler(false, "", [])
            }
        }
    }
}
