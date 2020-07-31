//
//  PublicProfileViewController.swift
//  Lavoro
//
//  Created by Manish on 18/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import ApplozicSwift
import InputBarAccessoryView
import IQKeyboardManagerSwift

class PublicProfileViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    let profileService = ProfileService()
    var profileId: String?
    var publicProfile: PublicProfile?
    var isDataLoaded = false
    @IBOutlet weak var userImage: UIImageView!
    let inputBar: InputBarAccessoryView = IMessageInputBar()
    private var keyboardManager = KeyboardManager()
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerParentView: UIView!
    var headerView = PublicProfileHeaderView.fromNib(named: "PublicProfileHeaderView")
    
    var stateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 250/255, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        fetchData()
        inputBar.topStackView.addArrangedSubview(stateView)
        manageKeyboard()
    }
    
    func setupView() {
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .default
        headerHeightConstraint.constant = UIScreen.main.bounds.width
        headerParentView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
        headerParentView.isHidden = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        setupViewForSelf()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setupViewForSelf() {
        guard let profileId = profileId, profileId == AuthUser.getAuthUser()?.id else {
            return
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "editPublicProfile"), style: .done, target: self, action: #selector(editTagline))
        self.navigationController?.navigationBar.tintColor = .white
        headerView.heartButton.isHidden = true
        headerView.commentsButton.isHidden = true
    }
    
    @objc func handleTap() {
        self.inputBar.inputTextView.resignFirstResponder()
    }
    
    @objc func editTagline() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "UpdateTaglineViewController") as! UpdateTaglineViewController
        viewController.delegate = self
        viewController.lastTagline = publicProfile?.tagline ?? ""
        self.tabBarController?.present(viewController, animated: true, completion: nil)
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let backImage = UIImage(named: "ic_back_white")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(backButton))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func manageKeyboard() {
        keyboardManager.bind(to: tableview)
        keyboardManager.on(event: .didShow) { [weak self] (notification) in
            self?.bottomConstraint.constant = notification.endFrame.height
        }.on(event: .willShow) { [weak self] (notification) in
            self?.bottomConstraint.constant = notification.endFrame.height
        }.on(event: .didHide) { [weak self] _ in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.bottomConstraint.constant = barHeight
        }.on(event: .willHide) { [weak self] _ in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.bottomConstraint.constant = barHeight
        }.on(event: .willChangeFrame) { [weak self] (notification) in
            print(notification.endFrame.height)
            self?.bottomConstraint.constant = notification.endFrame.height
        }
    }

    func fetchData() {
        guard let profileId = profileId else {
            return
        }
        if publicProfile == nil {
            self.showLoadingView()
        }
        profileService.getPublicProfile(with: profileId) { [weak self] (success, message, publicProfile)  in
            self?.stopLoadingView()
            self?.publicProfile = publicProfile
            if let avatar = publicProfile?.avatar, let url = URL(string: avatar) {
                self?.userImage.sd_setImage(with: url, completed: nil)
                self?.isDataLoaded = true
            }
            self?.headerParentView.isHidden = false
            self?.headerView.setupView(with: publicProfile)
            self?.headerView.commentsButton.addTarget(self, action: #selector(self?.chatButtonTap), for: .touchUpInside)
            self?.headerView.heartButton.addTarget(self, action: #selector(self?.followButtonTap(button:)), for: .touchUpInside)
            self?.tableview.contentInset = UIEdgeInsets(top: UIScreen.main.bounds.width, left: 0, bottom: 0, right: 0)
            self?.view.endEditing(true)
            self?.tableview.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
        }
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func refreshView() {
        fetchData()
    }
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @IBAction func chatButtonTap() {
        guard let profileId = profileId else {
            return
        }
        chatManager.launchChatWith(contactId: profileId, from: self.tabBarController ?? self, configuration: ALKConfiguration())
    }
    
    @IBAction func followButtonTap(button: UIButton) {
        guard let profileId = profileId else {
            return
        }
        headerView.startFollowChangeAnimation()
        userService.changeFollowUser(with: profileId, isFollow: !button.isSelected) { [weak self] (success, message) in
            self?.refreshView()
            self?.headerView.stopFollowChangeAnimation()
        }
    }
    
    func sendComment(text: String) {
        guard let profileId = profileId else {
            return
        }
        self.inputBar.sendButton.startAnimating()
        profileService.postComment(with: profileId, comment: text) { [weak self] (success, message) in
            self?.inputBar.sendButton.stopAnimating()
            if success {
                self?.inputBar.inputTextView.text = ""
                self?.inputBar.inputTextView.resignFirstResponder()
                if let profile = self?.publicProfile, profile.comments.count > 0 {
                    self?.tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                self?.refreshView()
            } else {
                MessageViewAlert.showError(with: message ?? "Please try again")
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension PublicProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicProfile?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! PublicProfileTableViewCell
        cell.setupCell(with: publicProfile?.comments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let constantMinHeight = -(UIScreen.main.safeAreaTop() + 124 + (self.navigationController?.navigationBar.frame.size.height ?? 0))
        if tableview.contentOffset.y < constantMinHeight && tableview.contentOffset.y > -(UIScreen.main.bounds.width) {
            headerHeightConstraint.constant = abs(tableview.contentOffset.y)
            tableview.contentInset = UIEdgeInsets(top: abs(tableview.contentOffset.y), left: 0, bottom: 0, right: 0)
        }
    }
}


extension PublicProfileViewController {
    static func showProfile(on navigation:UINavigationController?, profileId: String) {
        guard let navigation = navigation else {
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "PublicProfileViewController") as! PublicProfileViewController
        viewController.profileId = profileId
        viewController.hidesBottomBarWhenPushed = true
        navigation.pushViewController(viewController, animated: true)
        viewController.hidesBottomBarWhenPushed = false
    }
}

extension PublicProfileViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendComment(text: text)
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        bottomConstraint.constant = size.height + 300 // keyboard size estimate
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {}
}

extension PublicProfileViewController: TaglineUpdatedDelegate {
    func taglineUpdated(_ tagline: String) {
        publicProfile?.tagline = tagline
        self.headerView.setupView(with: publicProfile)
    }
}
