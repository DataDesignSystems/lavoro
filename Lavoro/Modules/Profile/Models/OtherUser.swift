//
//  OtherUser.swift
//  Lavoro
//
//  Created by Manish on 06/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

public class OtherUser {
    public let id: String
    public let name: String
    public let avatar: String
    public let username: String
    public let isFavorite: Bool
    public let position: String
    public var isFollowing: Bool
    
    init(with json:[String: Any]) {
//        let fullname = ((json["first"] as? String ?? "") + " " + (json["last"] as? String ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
        self.name = json["username"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.avatar = json["avatar"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.position = json["position"] as? String ?? ""
        self.isFavorite = json["isFavorite"] as? Bool ?? false
        self.isFollowing = json["isFollowing"] as? Bool ?? false
    }
}
