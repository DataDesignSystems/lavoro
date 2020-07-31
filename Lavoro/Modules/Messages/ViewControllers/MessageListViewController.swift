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
    var messageThreads = [ALMessage]()
    var  applozicClient = ApplozicClient()
    let noFeedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "No message threads available!"
        label.textColor = UIColor(white: 0.20, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.applozicClient = ApplozicClient(applicationKey: ALChatManager.applicationId, with: self) as ApplozicClient
        applozicClient.subscribeToConversation()
    }
    
    func setupView() {
        tableview.backgroundView = UIView()
        tableview.backgroundView?.addSubview(noFeedLabel)
        noFeedLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            let backImage = UIImage(named: "ic_back_white")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(backButton))
            self.navigationController?.navigationBar.tintColor = .black
        }
        refreshChatMessage()
    }
    
    @objc
    fileprivate func refreshChatMessage() {
        appDelegate.updateBadgeCountForUnreadMessage()
        applozicClient.getLatestMessages(false, withOnlyGroups: false, withCompletionHandler: { [weak self] messageList, error in
            if let messageList = messageList as? [ALMessage] {
                self?.messageThreads = messageList
            }
            self?.tableview.reloadData()
            self?.noFeedLabel.isHidden = (self?.messageThreads.count != 0)
        })
        setUnreadCount()
        resetGroupMessageCount()
    }
    
    func setUnreadCount() {
        guard let tabBarController = self.tabBarController as? TabbarViewController else {
            return
        }

        let userService = ALUserService()
        if let totalUnreadCount = userService.getTotalUnreadCount() {
            if(totalUnreadCount.intValue > 0){
                UIApplication.shared.applicationIconBadgeNumber = totalUnreadCount.intValue
                tabBarController.messageTabbarItem()?.badgeValue = "\(totalUnreadCount)"
            }else{
                UIApplication.shared.applicationIconBadgeNumber = 0
                tabBarController.messageTabbarItem()?.badgeValue = nil
            }
        }
    }
    
    func resetGroupMessageCount() {
        applozicClient.getLatestMessages(false, withOnlyGroups: false, withCompletionHandler: { [weak self] messageList, error in
            if let messageList = messageList as? [ALMessage] {
                var groupMessageThreads = [NSNumber]()
                for message in messageList {
                    if let groupId = message.groupId {
                        groupMessageThreads.append(groupId)
                    }
                }
                
                for (index, groupId) in groupMessageThreads.enumerated() {
                    self?.applozicClient.markConversationRead(forGroup: groupId) { (response, error) in
                        if index == groupMessageThreads.count {
                            self?.setUnreadCount()
                        }
                    }
                }
            }
        })
    }
    
    func redirectToChat(with userId: String) {
        chatManager.launchChatWith(contactId: userId, from: self.tabBarController ?? self, configuration: ALKConfiguration())
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
        
        let message = messageThreads[indexPath.row]
        chatManager.launchChatWith(contactId: message.to, from: self.tabBarController ?? self, configuration: ALKConfiguration())
    }
}

extension MessageListViewController: ApplozicUpdatesDelegate {
    func onMessageReceived(_ alMessage: ALMessage!) {
        refreshChatMessage()
    }
    
    func onMessageSent(_ alMessage: ALMessage!) {
        
    }
    
    func onUserDetailsUpdate(_ userDetail: ALUserDetail!) {
        
    }
    
    func onMessageDelivered(_ message: ALMessage!) {
        
    }
    
    func onMessageDeleted(_ messageKey: String!) {
        
    }
    
    func onMessageDeliveredAndRead(_ message: ALMessage!, withUserId userId: String!) {
        
    }
    
    func onConversationDelete(_ userId: String!, withGroupId groupId: NSNumber!) {
        
    }
    
    func conversationRead(byCurrentUser userId: String!, withGroupId groupId: NSNumber!) {
        
    }
    
    func onUpdateTypingStatus(_ userId: String!, status: Bool) {
        
    }
    
    func onUpdateLastSeen(atStatus alUserDetail: ALUserDetail!) {
        
    }
    
    func onUserBlockedOrUnBlocked(_ userId: String!, andBlockFlag flag: Bool) {
        
    }
    
    func onChannelUpdated(_ channel: ALChannel!) {
        
    }
    
    func onAllMessagesRead(_ userId: String!) {
        
    }
    
    func onMqttConnectionClosed() {
        
    }
    
    func onMqttConnected() {
        
    }
    
    func onUserMuteStatus(_ userDetail: ALUserDetail!) {
        
    }
    
    
}
