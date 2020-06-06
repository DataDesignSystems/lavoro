//
//  MessageListViewController.swift
//  Lavoro
//
//  Created by Manish on 09/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import Applozic

class MessageListViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    var messageThreads = MessageThread.mockData()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThreads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.setupCell(for: messageThreads[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        let message = messageThreads[indexPath.row] as! ALMessage
        let chatManager = ALChatManager(applicationKey: ALChatManager.applicationId as NSString)
        chatManager.launchChatForUser(message.to, fromViewController: self)
         */ //will add once API and user created
    }
}
