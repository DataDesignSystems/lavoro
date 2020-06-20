//
//  UserService.swift
//  Lavoro
//
//  Created by Manish on 16/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
class UserService: BaseModuleService {
    static let term = "term"
    static let userId = "user_id"
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
    
    func searchUser(with text: String, completionHandler: @escaping ((Bool, String?, [OtherUser]) -> ())) {
        NS.getRequest(with: .searchUserByUsername, parameters: [UserService.term: text], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    var searchedUser = [OtherUser]()
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any], let profile = data["profile"] as? [String: Any] {
                        if let matchesJson = profile["matches"] as? [[String: Any]] {
                            for matches in matchesJson {
                                searchedUser.append(OtherUser(with: matches))
                            }
                        }
                    }
                    completionHandler(true, self?.getMessage(from: json), searchedUser)
                } else {
                    completionHandler(false, self?.getMessage(from: json), [])
                }
            case .failure( _):
                completionHandler(false, "", [])
            }
        }
    }
    
    func changeFollowUser(with userId: String, isFollow: Bool, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: isFollow ? .followUser : .removeFollowUser, parameters: [UserService.userId: userId], authToken: true) { [weak self] (response) in
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
