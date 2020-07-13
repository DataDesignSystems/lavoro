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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        likeButton.isSelected = feed.isLiked
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
    
    func setupView(with feed: CheckInProfile?) {
        guard let feed = feed else {
            return
        }
        initialise()
        nameLabel.text = feed.username
        heartCount.text = feed.likes_count
        commentsCount.text = feed.comment_count
        if let url = URL(string: feed.avatar) {
            userImageview.sd_setImage(with: url, completed: nil)
        }
        feedDescription.text = feed.user_comments
        likeButton.isSelected = feed.isLiked
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
    
    func startLoader() {
        activityIndicator.startAnimating()
        likeButton.isHidden = true
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
        likeButton.isHidden = false
    }
}
