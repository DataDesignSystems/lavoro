//
//  PublicProfile.swift
//  Lavoro
//
//  Created by Manish on 18/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

public struct PublicProfile {
    public let username: String
    public let name: String
    public let avatar: String
    public let follower_count: String
    public let comment_count: String
    public let isFollowing: Bool
    public let position: String
    public var tagline: String
    public let comments: [Comment]
    
    init(with json:[String: Any]) {
        let fullname = ((json["first"] as? String ?? "") + " " + (json["last"] as? String ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
        self.name = fullname.isEmpty ? (json["username"] as? String ?? "") : fullname
        self.avatar = json["avatar"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.position = json["position"] as? String ?? ""
        self.tagline = json["tagline"] as? String ?? ""
        self.follower_count = json["follower_count"] as? String ?? ""
        self.comment_count = json["comment_count"] as? String ?? ""
        self.isFollowing = json["isFollowing"] as? Bool ?? false
        self.comments = (json["comments"] as? [[String: Any]] ?? []).map({ obj in
            Comment(with: obj)
        })
    }
}

public struct Comment {
    public let username: String
    public let name: String
    public let avatar: String
    public let comment: String
    public let displayTime: String
    
    init(with json:[String: Any]) {
        let fullname = ((json["first"] as? String ?? "") + " " + (json["last"] as? String ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
        self.name = fullname.isEmpty ? (json["username"] as? String ?? "") : fullname
        self.avatar = json["avatar"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.comment = json["comment"] as? String ?? ""
        self.displayTime = json["display_time"] as? String ?? ""
    }
}
