//
//  MessageTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 09/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import Applozic

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var unreadMessageCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.setLayer(cornerRadius: 30)
        unreadMessageCount.setLayer(cornerRadius: 9, showBorder: true, borderWidth: 1.0, borderColor: .white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(for message: ALMessage) {
        let dbService = ALContactDBService()
        let contact = dbService.loadContact(byKey: "userId", value: message.to)
        if let avatar = contact?.contactImageUrl, let avatarURL = URL(string: avatar) {
            userImage.sd_setImage(with: avatarURL, completed: nil)
        }
        if let username = contact?.getDisplayName() {
            name.text = username
        }
        if let latestMessage = message.message {
            lastMessage.text  = latestMessage
        }
        if let date = message.getCreatedAtTime(true) {
            time.text = date
        }
        if let unreadCount = contact?.unreadCount {
            if unreadCount.intValue == 0 {
                lastMessage.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                unreadMessageCount.isHidden = true
            }
            else {
                lastMessage.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                unreadMessageCount.isHidden = false
                unreadMessageCount.text = "\(unreadCount.intValue)"
            }
        }

    }
}
