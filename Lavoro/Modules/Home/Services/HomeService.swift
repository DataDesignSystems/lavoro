//
//  HomeService.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class HomeService: BaseModuleService {
    static let code = "code"
    static let comment = "comment"
    static let feed = "feed"
    
    func getDashboardData(with completionHandler: @escaping ((Bool, String?, [Feed], [IGStory], [IGStory]) -> ())) {
        NS.getRequest(with: .dashboard, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    var feeds = [Feed]()
                    var followingMe = [IGStory]()
                    var following = [IGStory]()
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any], let dashboard =  data["dashboard"] as? [String: Any]{
                        if let feedJson = dashboard["feed"] as? [[String: Any]] {
                            for feed in feedJson {
                                feeds.append(Feed(with: feed))
                            }
                        }
                        if let followingJson = dashboard["following"] as? [[String: Any]] {
                            for followingUser in followingJson {
                                following.append(IGStory(with: followingUser))
                            }
                        }
                        if let followingMeJson = dashboard["following_me"] as? [[String: Any]] {
                            for followingUser in followingMeJson {
                                followingMe.append(IGStory(with: followingUser))
                            }
                        }
                    }
                    completionHandler(true, self?.getMessage(from: json), feeds, followingMe, following)
                } else {
                    completionHandler(false, self?.getMessage(from: json), [], [], [])
                }
            case .failure( _):
                completionHandler(false, "", [], [], [])
            }
        }
    }
    
    func getQRCode(completionHandler: @escaping ((Bool, String?, String?) -> ())) {
        NS.getRequest(with: .getMyQRcode, parameters: [:], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let qrCode = data["qr_code"] as? String {
                            completionHandler(true, self?.getMessage(from: json), qrCode)
                        } else {
                            completionHandler(false, self?.getMessage(from: json), nil)
                        }
                    } else {
                        completionHandler(false, self?.getMessage(from: json), nil)
                    }
                } else {
                    completionHandler(false, self?.getMessage(from: json), nil)
                }
            case .failure( _):
                completionHandler(false, "", nil)
            }
        }
    }
    
    func followUserByQR(qrCode: String, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.getRequest(with: .followUserByQR, parameters: [HomeService.code: qrCode.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? qrCode], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let result = data["result"] as? String, result == "done" {
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
    
    func postComment(with feedId: String, comment: String ,completionHandler: @escaping ((Bool, String?) -> ())) {
        let comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard comment.count > 0 else {
            completionHandler(false, "")
            return
        }
        NS.getRequest(with: .addCommentsToPublicProfile, parameters: [HomeService.feed: feedId, HomeService.comment: comment], authToken: true) { [weak self] (response) in
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
    
    func getFeedData(with feedId: String, completionHandler: @escaping ((Bool, String?, PublicProfile?) -> ())) {
        NS.getRequest(with: .userPublicProfile, parameters: [HomeService.feed: feedId], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any] {
                        if let profile = data["profile"] as? [[String: Any]], let profileData = profile.first {
                            completionHandler(true, self?.getMessage(from: json), PublicProfile(with: profileData))
                        } else {
                            completionHandler(false, self?.getMessage(from: json), nil)
                        }
                    } else {
                        completionHandler(false, self?.getMessage(from: json), nil)
                    }
                } else {
                    completionHandler(false, self?.getMessage(from: json), nil)
                }
            case .failure( _):
                completionHandler(false, "", nil)
            }
        }
    }

}
