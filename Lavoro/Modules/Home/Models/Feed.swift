
//
//  Feed.swift
//  Lavoro
//
//  Created by Manish on 01/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

enum FeedType: String {
    case checkIn = "check-in"
    case checkOut = "check-out"
    case unknown = "unknown"
}

enum LikeStatus {
    case loading
    case loaded
}

class Feed {
    let id: String
    let comments: String
    let status: String
    let user: FeedUser
    var likes: String
    let displayTime: String
    let timeEntered: Date
    var feedType: FeedType
    var location: Location
    let postedComment: String
    var isLiked: Bool
    var likeStatus: LikeStatus = .loaded

    init(with json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.comments = json["total_comments"] as? String ?? ""
        self.status = json["status"] as? String ?? ""
        self.likes = json["total_likes"] as? String ?? ""
        self.displayTime = json["display_time"] as? String ?? ""
        self.timeEntered = (json["time_entered"] as? String ?? "").toDate(dateFormat: "MM-dd-yyyy hh:mm a") ?? Date()
        self.feedType = FeedType(rawValue: (json["type"] as? String ?? "")) ?? .unknown
        self.user = FeedUser(with: (json["user"] as? [String: Any] ?? [:]))
        self.location = Location(with: (json["location"] as? [String: Any] ?? [:]))
        self.postedComment = json["posted_comment"] as? String ?? ""
        self.isLiked = json["liked"] as? Bool ?? false
    }
}

struct FeedUser {
    let id: String
    let username: String
    let avatar: String
    let isFavorite: Bool
    
    init(with json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.avatar = json["avatar"] as? String ?? ""
        self.isFavorite = json["isfavorite"] as? Bool ?? false
    }
}

struct Location {
    let id: String
    let name: String
    let address: String
    let suite: String
    let city: String
    let state: String
    let zip: String
    let phone: String
    let email: String
    let image: String
    let status: String
    
    init(with json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.address = json["address"] as? String ?? ""
        self.suite = json["suite"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.state = json["state"] as? String ?? ""
        self.zip = json["zip"] as? String ?? ""
        self.phone = json["phone"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.image = json["image"] as? String ?? ""
        self.status = json["status"] as? String ?? ""
    }
}
