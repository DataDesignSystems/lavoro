//
//  PublicProfileHeaderView.swift
//  Lavoro
//
//  Created by Manish on 18/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class PublicProfileHeaderView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heartCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    func initialise() {
        commentsButton.setLayer(cornerRadius: 6.0, showBorder: true, borderWidth: 1, borderColor: .white)
        heartButton.setLayer(cornerRadius: 1.0, showBorder: true, borderWidth: 1, borderColor: .clear)
        heartButton.setBackgroundImage(UIColor(hexString: "#FF2D55").image(), for: .selected)
        heartButton.setBackgroundImage(UIColor.clear.image(), for: .normal)
    }
    
    func setupView(with profile: PublicProfile?) {
        guard let profile = profile else {
            return
        }
        initialise()
        nameLabel.text = profile.name
        heartCount.text = profile.follower_count
        commentsCount.text = profile.comment_count
        profileDescription.text = profile.tagline
        heartButton.isSelected = profile.isFollowing
    }
    
    func startFollowChangeAnimation() {
        activityIndicator.startAnimating()
        heartButton.isHidden = true
    }
    
    func stopFollowChangeAnimation() {
        activityIndicator.stopAnimating()
        heartButton.isHidden = false
    }
}
