//
//  CheckInProfile.swift
//  Lavoro
//
//  Created by Manish on 13/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
class CheckInProfile {
    public let id: String
    public let username: String
    public let description: String
    public let user_comments: String
    public let avatar: String
    public var likes_count: String
    public let comment_count: String
    public var isLiked: Bool
    public let position: String
    public let tagline: String
    public let comments: [FeedComment]
    var feedType: FeedType
    var location: Location
    
    init(with json:[String: Any]) {
        self.id = json["avatar"] as? String ?? ""
        self.description = json["avatar"] as? String ?? ""
        self.avatar = json["avatar"] as? String ?? ""
        self.user_comments = json["user_comments"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.position = json["position"] as? String ?? ""
        self.tagline = json["tagline"] as? String ?? ""
        self.likes_count = json["likes_count"] as? String ?? ""
        self.comment_count = json["comment_count"] as? String ?? ""
        self.isLiked = json["liked"] as? Bool ?? false
        self.comments = (json["comments"] as? [[String: Any]] ?? []).map({ obj in
            FeedComment(with: obj)
        })
        self.feedType = FeedType(rawValue: (json["type"] as? String ?? "")) ?? .unknown
        self.location = Location(with: (json["location"] as? [String: Any] ?? [:]))
    }
}

public struct FeedComment {
    public let id: String
    public let commentId: String
    public let username: String
    public let name: String
    public let avatar: String
    public let comment: String
    public let displayTime: String
    
    init(with json:[String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.commentId = json["comment_id"] as? String ?? ""
        let fullname = ((json["first"] as? String ?? "") + " " + (json["last"] as? String ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
        self.name = fullname.isEmpty ? (json["username"] as? String ?? "") : fullname
        self.avatar = json["avatar"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.comment = json["comment"] as? String ?? ""
        self.displayTime = json["display_time"] as? String ?? ""
    }
}
