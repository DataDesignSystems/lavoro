//
//  MessageThread.swift
//  Lavoro
//
//  Created by Manish on 09/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
struct MessageThread {
    var name: String
    var lastMessage: String
    var time: String
    var imageName: String
    
    static func mockData() -> [MessageThread]{
        return [MessageThread(name: "Ellen Lambert", lastMessage: "Hey! How's it going?", time: "04:04AM", imageName: "dummyUser"),
                MessageThread(name: "Connor Frazier", lastMessage: "What kind of music do you like? ", time: "08:58PM", imageName: "dummyUser"),
                MessageThread(name: "Ellen Lambert", lastMessage: "Hey! How's it going?", time: "04:04AM", imageName: "dummyUser"),
                MessageThread(name: "Ellen Lambert", lastMessage: "Hey! How's it going?", time: "04:04AM", imageName: "dummyUser"),
                MessageThread(name: "Ellen Lambert", lastMessage: "Hey! How's it going?", time: "04:04AM", imageName: "dummyUser"),
                MessageThread(name: "Ellen Lambert", lastMessage: "Hey! How's it going?", time: "04:04AM", imageName: "dummyUser"),
                MessageThread(name: "Ellen Lambert", lastMessage: "Hey! How's it going?", time: "04:04AM", imageName: "dummyUser")]
    }
}
