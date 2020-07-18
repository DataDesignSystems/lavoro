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
    static let comments = "comments"
    static let followerId = "follower_id"
    static let blacklist = "blacklist"
    
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
    
    func getMyBlacklist(with completionHandler: @escaping ((Bool, String?, [OtherUser]) -> ())) {
        NS.getRequest(with: .getMyBlacklist, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    var blacklist = [OtherUser]()
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let blacklistJson = data["dashboard"] as? [[String: Any]] {
                            for blacklistUser in blacklistJson {
                                blacklist.append(OtherUser(with: blacklistUser))
                            }
                        }
                    }
                    completionHandler(true, self?.getMessage(from: json), blacklist)
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
    func updateMyBlacklist(with userId: String, isBlacklist: Bool, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: .updateMyBlacklist, parameters: [UserService.followerId: userId, UserService.blacklist: isBlacklist ? "true" : "false"], authToken: true) { [weak self] (response) in
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
    
    func getMyUserProfile(with completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: .getMyUserProfile, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let profileData = data["profile"] as? [String: Any] {
                            let authUser = AuthUser(json: profileData, token: AuthUser.getAuthUser()?.authToken ?? "")
                            authUser.saveUser()
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
    func sendGroupMessage(with message: String, completionHandler: @escaping ((Bool, String?) -> ())) {
        let message = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard message.count > 0 else {
            completionHandler(false, "")
            return
        }
        NS.getRequest(with: .sendGroupMessage, parameters: [UserService.comments: message],  authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let response = data["response"] as? [String: Any], let status = response["status"] as? String, status == "success" {
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
