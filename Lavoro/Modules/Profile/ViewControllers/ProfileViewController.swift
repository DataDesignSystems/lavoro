//
//  ProfileViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!

    var profileInfo = [[ProfileInfo(icon: "MyWorkGroupLocations", title: "My Work Locations", type: .myWorkLocations),
                       ProfileInfo(icon: "MySchedule", title: "My Schedule", type: .mySchedule),
                       ProfileInfo(icon: "Group", title: "Send Group Message", type: .sendGroupMessage)],
                       [ProfileInfo(icon: "Followers", title: "Followers", type: .followers),
                       ProfileInfo(icon: "WhoIFollow", title: "Who I Follow", type: .whoIFollow),
                       ProfileInfo(icon: "Messages", title: "Messages", type: .messages),
                       ProfileInfo(icon: "Blacklist", title: "Blacklist", type: .blacklist),
                       ProfileInfo(icon: "Settings", title: "Settings", type: .settings)]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
        
    func setupView() {
        userImage.setLayer(cornerRadius: 6.0)
        editButton.setLayer(cornerRadius: 10.0)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileInfo.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileInfo[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.setupCell(with: profileInfo[indexPath.section][indexPath.row])
        return cell
    }
}
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = profileInfo[indexPath.section][indexPath.row]
        switch object.type {
        case .mySchedule:
            self.performSegue(withIdentifier: "mySchedule", sender: self)
        case .myWorkLocations:
            self.performSegue(withIdentifier: "myWorkLocations", sender: self)
        case .whoIFollow:
            self.performSegue(withIdentifier: "findFriends", sender: self)
        case .followers:
            self.performSegue(withIdentifier: "followers", sender: self)
        default:
            print(object.title)
        }
    }
}

struct ProfileInfo {
    var icon: String
    var title: String
    var type: ProfileType
}

enum ProfileType {
    case myWorkLocations
    case mySchedule
    case sendGroupMessage
    case followers
    case whoIFollow
    case messages
    case blacklist
    case settings
}
