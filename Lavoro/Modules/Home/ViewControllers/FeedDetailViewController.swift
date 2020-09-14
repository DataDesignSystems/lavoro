//
//  FeedDetailViewController.swift
//  Lavoro
//
//  Created by Manish on 04/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import IQKeyboardManagerSwift

class FeedDetailViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    var feed: Feed?
    var checkInProfile: CheckInProfile?
    @IBOutlet weak var locationImage: UIImageView!
    let inputBar: InputBarAccessoryView = IMessageInputBar()
    private var keyboardManager = KeyboardManager()
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerParentView: UIView!
    var headerView = FeedDetailHeaderView.fromNib(named: "FeedDetailHeaderView")
    let homeService = HomeService()
    var stateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 250/255, alpha: 1)
        return view
    }()
    
    var locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupView()
        fetchData()
        inputBar.topStackView.addArrangedSubview(stateView)
        manageKeyboard()
        bindData()
    }
    
    func bindData() {
        guard let feed = feed else {
            return
        }
        if let url = URL(string: feed.location.image) {
            locationImage.sd_setImage(with: url, completed: nil)
        }
        headerView.setupView(with: feed)
    }
    
    func setupView() {
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .default
        headerHeightConstraint.constant = UIScreen.main.bounds.width
        headerParentView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
        headerView.likeButton.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.addGestureRecognizer(tapGesture)
        switch feed?.feedType {
        case .checkIn:
            locationNameLabel.text = "Checked In"
        case .checkOut:
            locationNameLabel.text = "Checked Out"
        case .unknown:
            locationNameLabel.text = "Unknown"
        default:
            print("error")
        }
    }
    
    @objc func likeButtonTap( button: UIButton) {
        guard let checkInProfile = checkInProfile else {
            return
        }
        headerView.startLoader()
        homeService.updateCheckinLike(with: checkInProfile.id, isLiked: !checkInProfile.isLiked) { [weak self] (success, message, isLiked, totalCount) in
            self?.headerView.stopLoader()
            if success {
                checkInProfile.isLiked = isLiked ?? !checkInProfile.isLiked
                checkInProfile.likes_count = totalCount ?? checkInProfile.likes_count
                self?.headerView.setupView(with: checkInProfile)
            } else {
                if let message = message, message.count > 0 {
                    MessageViewAlert.showError(with: message)
                }
            }
        }
    }

    
    func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let backImage = UIImage(named: "ic_back_white")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(backButton))
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.titleView = locationNameLabel

    }
    
    @objc func handleTap() {
        self.inputBar.inputTextView.resignFirstResponder()
    }
    
    func manageKeyboard() {
        keyboardManager.bind(to: tableview)
        keyboardManager.on(event: .didShow) { [weak self] (notification) in
            self?.bottomConstraint.constant = notification.endFrame.height
        }.on(event: .didHide) { [weak self] _ in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.bottomConstraint.constant = barHeight
        }
    }
    
    func setupWithCheckInProfileObject() {
        switch checkInProfile?.feedType {
        case .checkIn:
            locationNameLabel.text = "Checked In"
        case .checkOut:
            locationNameLabel.text = "Checked Out"
        case .unknown:
            locationNameLabel.text = "Unknown"
        default:
            print("error")
        }
        if let imageURL = checkInProfile?.location.image, let url = URL(string: imageURL) {
            locationImage.sd_setImage(with: url, completed: nil)
        }
    }

    func fetchData() {
        guard let feedId = feed?.id else {
            return
        }
        self.showLoadingView()
        homeService.getFeedData(with: feedId) { [weak self] (success, message, checkInProfile)  in
            self?.checkInProfile = checkInProfile
            self?.headerView.setupView(with: checkInProfile)
            self?.setupWithCheckInProfileObject()
            self?.stopLoadingView()
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
    
    func sendComment(text: String) {
        guard let feedId = feed?.id else {
            return
        }
        self.inputBar.sendButton.startAnimating()
        homeService.postComment(with: feedId, comment: text) { [weak self] (success, message) in
            self?.inputBar.sendButton.stopAnimating()
            if success {
                self?.inputBar.inputTextView.text = ""
                self?.inputBar.inputTextView.resignFirstResponder()
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

extension FeedDetailViewController {
    static func showFeedDetail(on navigation:UINavigationController?, feed: Feed) {
        guard let navigation = navigation else {
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
        viewController.feed = feed
        viewController.hidesBottomBarWhenPushed = true
        navigation.pushViewController(viewController, animated: true)
        viewController.hidesBottomBarWhenPushed = false
    }
}
extension FeedDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkInProfile?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! FeedCommentTableViewCell
        cell.setupCell(with: checkInProfile?.comments[indexPath.row])
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
extension FeedDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendComment(text: text)
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        bottomConstraint.constant = size.height + 300 // keyboard size estimate
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {}
}
