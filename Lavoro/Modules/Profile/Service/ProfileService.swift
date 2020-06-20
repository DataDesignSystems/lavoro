//
//  ProfileService.swift
//  Lavoro
//
//  Created by Manish on 18/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
class ProfileService: BaseModuleService {
    static let userId: String = "user"
    static let comment: String = "comment"
    static let tagline: String = "tagline"

    func getPublicProfile(with userId: String, completionHandler: @escaping ((Bool, String?, PublicProfile?) -> ())) {
        NS.getRequest(with: .userPublicProfile, parameters: [ProfileService.userId: userId], authToken: true) { [weak self] (response) in
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
    
    func postComment(with userId: String, comment: String ,completionHandler: @escaping ((Bool, String?) -> ())) {
        let comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard comment.count > 0 else {
            completionHandler(false, "")
            return
        }
        NS.getRequest(with: .addCommentsToPublicProfile, parameters: [ProfileService.userId: userId, ProfileService.comment: comment], authToken: true) { [weak self] (response) in
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
    
    func updateTagline(with tagline: String ,completionHandler: @escaping ((Bool, String?) -> ())) {
        let tagline = tagline.trimmingCharacters(in: .whitespacesAndNewlines)
        guard tagline.count > 0 else {
            completionHandler(false, "")
            return
        }
        NS.getRequest(with: .tagline, parameters: [ProfileService.tagline: tagline], authToken: true) { [weak self] (response) in
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
