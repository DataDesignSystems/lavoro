//
//  FollowTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 06/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    let userService = UserService()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.setLayer(cornerRadius: 30)
        followButton.setLayer(cornerRadius: 4, showBorder: true, borderWidth: 1, borderColor: UIColor(hexString: "FF2D55"))
        followButton.setTitle("Following", for: .selected)
        followButton.setTitle("Follow", for: .normal)
        followButton.setBackgroundImage(UIColor(hexString: "#FF2D55").image(), for: .selected)
        followButton.setBackgroundImage(UIColor.clear.image(), for: .normal)
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(followButton)
        }
        followButton.addTarget(self, action: #selector(followButtonTap(button:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(with object: OtherUser) {
        name.text = object.name
        profession.text = object.position
        if let url = URL(string: object.avatar) {
            userImage.sd_setImage(with: url, completed:  nil)
        }
        followButton.isSelected = object.isFollowing
        followButton.tag = Int(object.id) ?? -1
    }
    
    func startAnimation() {
        followButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func stopAnimation() {
        followButton.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    @IBAction func followButtonTap(button: UIButton) {
        guard button.tag != -1 else {
            return
        }
        self.startAnimation()
        userService.changeFollowUser(with: "\(button.tag)", isFollow: !followButton.isSelected) { [weak self] (success, message) in
            self?.stopAnimation()
        }
    }
}
