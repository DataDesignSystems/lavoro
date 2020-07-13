//
//  FeedCommentTableViewCell.swift
//  Lavoro
//
//  Created by Manish on 13/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class FeedCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.setLayer(cornerRadius: 20)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with comment: FeedComment?) {
        guard let comment = comment else {
            return
        }
        nameLabel.text = comment.name
        commentsLabel.text = comment.comment
        if let url = URL(string: comment.avatar) {
            userImage.sd_setImage(with: url, completed: nil)
        }
        timeLabel.text = comment.displayTime
    }

}
