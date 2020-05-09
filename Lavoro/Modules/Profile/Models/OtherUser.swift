//
//  OtherUser.swift
//  Lavoro
//
//  Created by Manish on 06/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

struct OtherUser {
    var name: String
    var profession: String
    var imageName: String
    
    static func mockdata() -> [OtherUser] {
        return [OtherUser(name: "Josie Johnston", profession: "Server", imageName: "dummyUser"),
                OtherUser(name: "Eddie Simmons", profession: "Bartender", imageName: "dummyUser"),
                OtherUser(name: "Noah Guzman", profession: "Server", imageName: "dummyUser"),
                OtherUser(name: "Bradley West", profession: "Bartender", imageName: "dummyUser"),
                OtherUser(name: "Allen Day", profession: "Server", imageName: "dummyUser"),
                OtherUser(name: "Noah Guzman", profession: "Bartender", imageName: "dummyUser"),
                OtherUser(name: "Bradley West", profession: "Bartender", imageName: "dummyUser"),
                OtherUser(name: "Jesus Reeves", profession: "Bartender", imageName: "dummyUser"),
                OtherUser(name: "Allen Day", profession: "Server", imageName: "dummyUser")]
    }
}

