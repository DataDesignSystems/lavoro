//
//  FeedDetailHeaderView.swift
//  Lavoro
//
//  Created by Manish on 04/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class FeedDetailHeaderView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heartCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var feedDescription: UILabel!
    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var checkedInLabel: UILabel!
    
    func initialise() {
        userImageview.setLayer(cornerRadius: 25)
        checkedInLabel.setLayer(cornerRadius: 4)
    }
    
    func setupView(with feed: Feed?) {
        guard let feed = feed else {
            return
        }
        initialise()
        nameLabel.text = feed.user.username
        heartCount.text = feed.likes
        commentsCount.text = feed.comments
        if let url = URL(string: feed.user.avatar) {
            userImageview.sd_setImage(with: url, completed: nil)
        }
        feedDescription.text = feed.postedComment
        switch feed.feedType {
        case .checkIn:
            checkedInLabel.text = "  \(feed.location.name)  "
            checkedInLabel.backgroundColor = UIColor(hexString: "4CD964")
        case .checkOut:
            checkedInLabel.text = "  \(feed.location.name)  "
            checkedInLabel.backgroundColor = UIColor(hexString: "FF2D55")
        case .unknown:
            checkedInLabel.text = ""
        }
    }
}
