//
//  FollowTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 06/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class BlacklistTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var blacklistButton: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    let userService = UserService()
    weak var delegate: ChangeFollowStatus?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.setLayer(cornerRadius: 30)
        blacklistButton.setLayer(cornerRadius: 4, showBorder: true, borderWidth: 1, borderColor: UIColor(hexString: "FF2D55"))
        blacklistButton.setTitle("UnBlock", for: .selected)
        blacklistButton.setTitle("Block", for: .normal)
        blacklistButton.setBackgroundImage(UIColor(hexString: "#FF2D55").image(), for: .selected)
        blacklistButton.setBackgroundImage(UIColor.clear.image(), for: .normal)
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(blacklistButton)
        }
        blacklistButton.addTarget(self, action: #selector(blacklistButtonTap(button:)), for: .touchUpInside)
        guard let authUser = AuthUser.getAuthUser() else {
            return
        }
        blacklistButton.isHidden = (authUser.type != .serviceProvider)
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
        blacklistButton.isSelected = object.isBlacklist
        blacklistButton.tag = Int(object.id) ?? -1
    }
    
    func startAnimation() {
        blacklistButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func stopAnimation() {
        blacklistButton.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    @IBAction func blacklistButtonTap(button: UIButton) {
        guard button.tag != -1 else {
            return
        }
        delegate?.apiCallInitiated(userId: button.tag)
        self.startAnimation()
        userService.updateMyBlacklist(with: "\(button.tag)", isBlacklist: !blacklistButton.isSelected) { [weak self] (success, message) in
            self?.stopAnimation()
            self?.delegate?.apiCallEnd(userId: button.tag, success: success)
        }
    }
}
