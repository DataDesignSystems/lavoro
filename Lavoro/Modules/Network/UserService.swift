//
//  UserService.swift
//  Lavoro
//
//  Created by Manish on 16/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
class UserService: BaseModuleService {
    func getWhoIFollow(with completionHandler: @escaping ((Bool, String?, [OtherUser]) -> ())) {
        NS.getRequest(with: .whoIFollow, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    var following = [OtherUser]()
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let followingJson = data["following"] as? [[String: Any]] {
                            for followingUser in followingJson {
                                following.append(OtherUser(with: followingUser))
                            }
                        }
                    }
                    completionHandler(true, self?.getMessage(from: json), following)
                } else {
                    completionHandler(false, self?.getMessage(from: json), [])
                }
            case .failure( _):
                completionHandler(false, "", [])
            }
        }
    }
    
    func getFollowingMe(with completionHandler: @escaping ((Bool, String?, [OtherUser]) -> ())) {
        NS.getRequest(with: .followingMe, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    var following = [OtherUser]()
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let followingJson = data["followers"] as? [[String: Any]] {
                            for followingUser in followingJson {
                                following.append(OtherUser(with: followingUser))
                            }
                        }
                    }
                    completionHandler(true, self?.getMessage(from: json), following)
                } else {
                    completionHandler(false, self?.getMessage(from: json), [])
                }
            case .failure( _):
                completionHandler(false, "", [])
            }
        }
    }
}
