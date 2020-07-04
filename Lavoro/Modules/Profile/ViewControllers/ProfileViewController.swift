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
    @IBOutlet weak var followerTextLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!

    var serviceProfileInfo = [[ProfileInfo(icon: "My Public Profile", title: "My Public Profile", type: .publicProfile),
                               ProfileInfo(icon: "MyWorkGroupLocations", title: "My Work Locations", type: .myWorkLocations),
                               ProfileInfo(icon: "MySchedule", title: "My Schedule", type: .mySchedule),
                               ProfileInfo(icon: "Group", title: "Send Group Message", type: .sendGroupMessage)],
                              [ProfileInfo(icon: "Followers", title: "Followers", type: .followers),
                               ProfileInfo(icon: "WhoIFollow", title: "Who I Follow", type: .whoIFollow),
                               ProfileInfo(icon: "Messages", title: "Messages", type: .messages),
                               ProfileInfo(icon: "Blacklist", title: "Blacklist", type: .blacklist),
                               ProfileInfo(icon: "Settings", title: "Settings", type: .settings),
                               ProfileInfo(icon: "logout", title: "Logout", type: .logout)]]
    
    var customerProfileInfo = [[ProfileInfo(icon: "WhoIFollow", title: "Who I Follow", type: .whoIFollow),
                                ProfileInfo(icon: "Messages", title: "Messages", type: .messages),
                                ProfileInfo(icon: "Settings", title: "Settings", type: .settings),
                                ProfileInfo(icon: "logout", title: "Logout", type: .logout)]]
    
    var profileInfo = [[ProfileInfo]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backImage = UIImage(named: "ic_back_white")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(backButton))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#F7F8FA")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Profile"
        refreshView()
        updateUserProfileData()
    }
    
    func updateUserProfileData() {
        userService.getMyUserProfile { [weak self] (success, message) in
            self?.refreshView()
        }
    }
    
    func refreshView() {
        if let authUser = AuthUser.getAuthUser() {
            if let url = URL(string: authUser.avatar) {
                userImage.sd_setImage(with: url, completed: nil)
            }
            usernameLabel.text = "@\(authUser.username)"
            nameLabel.text = "\(authUser.first) \(authUser.last)"
            followerLabel.text = authUser.follower
            followingLabel.text = authUser.following
            likesLabel.text = authUser.likes
        }
    }
    
    func setupView() {
        userImage.setLayer(cornerRadius: 6.0)
        editButton.setLayer(cornerRadius: 10.0)
        if let authUser = AuthUser.getAuthUser(), authUser.type == .serviceProvider {
            profileInfo = serviceProfileInfo
            followerLabel.isHidden = false
            followerTextLabel.isHidden = false
        } else {
            profileInfo = customerProfileInfo
            followerLabel.isHidden = true
            followerTextLabel.isHidden = true
        }
    }
    
    @IBAction func editProfile() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "RegisterationViewController") as? RegisterationViewController {
            vc.isEditingProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func displayWhoIFollowPage() {
        self.performSegue(withIdentifier: "findFriends", sender: self)
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
        case .logout:
            AuthUser.logout()
            appDelegate.presentLoginFlow()
        case .messages:
            let storyboard = UIStoryboard(name: "Messages", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "MessageListViewController") as? MessageListViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .publicProfile:
            guard let profileId = AuthUser.getAuthUser()?.id else {
                return
            }
            PublicProfileViewController.showProfile(on: self.navigationController, profileId: profileId)
        default:
            print(object.title)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    case logout
    case publicProfile
}
