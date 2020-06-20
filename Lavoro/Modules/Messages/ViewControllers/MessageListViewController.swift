//
//  MessageListViewController.swift
//  Lavoro
//
//  Created by Manish on 09/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import Applozic
import ApplozicSwift

class MessageListViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    var messageThreads = NSMutableArray()
    fileprivate let dbServices = ALMessageDBService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshChatMessage()
    }
    
    @objc
    fileprivate func refreshChatMessage() {
        appDelegate.updateBadgeCountForUnreadMessage()
        dbServices.delegate = self
        dbServices.getMessages(nil)
        
        let userService = ALUserService()
        if let totalUnreadCount = userService.getTotalUnreadCount() {
            if(totalUnreadCount.intValue > 0){
                UIApplication.shared.applicationIconBadgeNumber = totalUnreadCount.intValue
                self.tabBarController?.tabBar.items![2].badgeValue = "\(totalUnreadCount)"
            }else{
                UIApplication.shared.applicationIconBadgeNumber = 0
                self.tabBarController?.tabBar.items![2].badgeValue = nil
            }
        }
        
    }
}

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThreads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.setupCell(for: messageThreads[indexPath.row] as! ALMessage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = messageThreads[indexPath.row] as! ALMessage
        chatManager.launchChatWith(contactId: message.to, from: self.tabBarController ?? self, configuration: ALKConfiguration())
    }
}

extension MessageListViewController : ALMessagesDelegate {
    func updateMessageList(_ messagesArray: NSMutableArray!) {
        
    }

    func getMessagesArray(_ messagesArray: NSMutableArray!) {
        self.messageThreads = messagesArray
        self.tableview.reloadData()
    }
}



