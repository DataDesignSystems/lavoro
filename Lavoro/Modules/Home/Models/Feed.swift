
//
//  Feed.swift
//  Lavoro
//
//  Created by Manish on 01/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

enum FeedType {
    case checkIn
    case checkOut
}

struct Feed {
    var username: String
    var feedType: FeedType
    var date: Date
    var dateInString: String
    var locationName: String
    var message: String
    var likesCount: Int
    var commentsCount: Int
    var userImage: String
    
    static func mockData() -> [Feed] {
        return [Feed(username: "Alice Jones", feedType: .checkIn, date: Date(), dateInString: "2 hours ago", locationName: "Butterbee's American Grille", message: "Butterbee's American Grille", likesCount: 231, commentsCount: 122, userImage: ""),
                Feed(username: "Alice Jones", feedType: .checkOut, date: Date(), dateInString: "12 hours ago", locationName: "Butterbee's American Grille", message: "Butterbee's American Grille", likesCount: 675, commentsCount: 353, userImage: ""),
                Feed(username: "John Doe", feedType: .checkIn, date: Date(), dateInString: "6 hours ago", locationName: "Butterbee's American Grille", message: "Butterbee's American Grille", likesCount: 635, commentsCount: 833, userImage: ""),
                Feed(username: "John Doe", feedType: .checkOut, date: Date(), dateInString: "22 hours ago", locationName: "Butterbee's American Grille", message: "Butterbee's American Grille", likesCount: 123, commentsCount: 879, userImage: "")]
    }
}
