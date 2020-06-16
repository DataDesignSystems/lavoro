//
//  IGStory.swift
//
//  Created by Ranjith Kumar on 9/8/17
//  Copyright (c) DrawRect. All rights reserved.
//

import Foundation

public class IGStory {
    // Note: To retain lastPlayedSnapIndex value for each story making this type as class
    public var snapsCount: Int
    public var snaps: [IGSnap]
    public var internalIdentifier: String
    public var lastUpdated: Int
    public var user: OtherUser
    var lastPlayedSnapIndex = 0
    var isCompletelyVisible = false
    var isCancelledAbruptly = false
    
    init(with json:[String: Any]) {
        self.snapsCount = 0
        self.snaps = []
        self.internalIdentifier = ""
        self.lastUpdated = 0
        self.user = OtherUser(with: json)
    }
}

extension IGStory: Equatable {
    public static func == (lhs: IGStory, rhs: IGStory) -> Bool {
        return lhs.internalIdentifier == rhs.internalIdentifier
    }
}
