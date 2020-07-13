//
//  HomeFeedsViewController.swift
//  Lavoro
//
//  Created by Manish on 01/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import ApplozicSwift
import QRCodeReader

class HomeFeedsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIButton!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var storiesView: UIView!
    private var igStoriesView: IGHomeView!
    private var followingViewModel: IGHomeViewModel = IGHomeViewModel()
    private var followingMeViewModel: IGHomeViewModel = IGHomeViewModel()
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followingMeButton: UIButton!
    let homeService = HomeService()
    var feeds = [Feed]()
    let noFeedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "No feeds available!\nFollow users to see their feeds"
        label.textColor = UIColor(white: 0.20, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(fetchData),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton = true
            $0.showOverlayView = true
            $0.cancelButtonTitle = ""
            let readerView = QRCodeReaderContainer(displayable: ScannerOverlay())
            $0.readerView = readerView
        }
        return QRCodeReaderViewController(builder: builder)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        appDelegate.updateBadgeCountForUnreadMessage()
        setProfileData()
        self.fetchData()
    }
    
    @objc func fetchData() {
        if self.feeds.count == 0 {
            self.showLoadingView()
        }
        noFeedLabel.isHidden = true
        homeService.getDashboardData { [weak self] (success, message, feeds, followingMe, following)   in
            self?.feeds = feeds
            self?.noFeedLabel.isHidden = !feeds.isEmpty
            self?.followingMeViewModel.setStories(stories: IGStories(with: followingMe))
            self?.followingViewModel.setStories(stories: IGStories(with: following))
            self?.stopLoadingView()
            self?.tableView.reloadData()
            self?.igStoriesView.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func setupView() {
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        userImage.setLayer(cornerRadius: 19)
        headerView.outerShadow(shadowOpacity: 0.05, shadowColor: .black)
        igStoriesView = IGHomeView()
        storiesView.addSubview(igStoriesView)
        igStoriesView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        igStoriesView.collectionView.delegate = self
        igStoriesView.collectionView.dataSource = self
        igStoriesView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundView = UIView()
        tableView.backgroundView?.addSubview(noFeedLabel)
        noFeedLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
        }
        followingButton.isSelected = true
        followingMeButton.isSelected = false
        self.tableView.addSubview(self.refreshControl)
    }

    func setProfileData() {
        if let authUser = AuthUser.getAuthUser() {
            if let url = URL(string: authUser.avatar) {
                userImage.sd_setImage(with: url, for: .normal, completed: nil)
            }
            if authUser.type != .serviceProvider {
                self.followingMeButton.isHidden = true
            }
        }
    }
    
    @objc func showUserProfileButtonsTap( button: UIButton) {
        let profileId = feeds[button.tag].user.id
        PublicProfileViewController.showProfile(on: self.navigationController, profileId: profileId)
    }
    
    @objc func showFeedDetailButtonTap( button: UIButton) {
        FeedDetailViewController.showFeedDetail(on: self.navigationController, feed: feeds[button.tag])
    }

    @objc func likeButtonTap( button: UIButton) {
        let feed = feeds[button.tag]
        feed.likeStatus = .loading
        tableView.reloadRows(at: [IndexPath(row: button.tag, section: 0)], with: .automatic)
        homeService.updateCheckinLike(with: feed.id, isLiked: !feed.isLiked) { [weak self] (success, message, isLiked, totalCount) in
            feed.likeStatus = .loaded
            if success {
                feed.isLiked = isLiked ?? !feed.isLiked
                feed.likes = totalCount ?? feed.likes
                self?.tableView.reloadRows(at: [IndexPath(row: button.tag, section: 0)], with: .automatic)
            } else {
                if let message = message, message.count > 0 {
                    MessageViewAlert.showError(with: message)
                }
            }
        }
    }

    @IBAction func editProfile() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getSelectedViewModel() -> IGHomeViewModel {
        return followingMeButton.isSelected ? followingMeViewModel : followingViewModel
    }
    
    @IBAction func followButtonToggle(button: UIButton) {
        if button == followingMeButton && (followingMeViewModel.getStories()?.stories.count ?? 0) == 0 {
            MessageViewAlert.showWarning(with: Validation.Warning.noFollowers.rawValue)
            return
        }
        followingMeButton.isSelected = false
        followingButton.isSelected = false
        button.isSelected = true
        igStoriesView.collectionView.reloadData()
    }
    
    func showWhoIFollow() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "WhoCanIFollowViewController") as? WhoCanIFollowViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func startScan() {
        readerVC.completionBlock = { [weak self] (result: QRCodeReaderResult?) in
           self?.readerVC.dismiss(animated: true) { [weak self] in
            guard let value = result?.value else {
                return
            }
            self?.showLoadingView()
            self?.homeService.followUserByQR(qrCode: value, completionHandler: { (success, message) in
                self?.stopLoadingView()
                if success {
                    if let message = message, message.count > 0 {
                        MessageViewAlert.showSuccess(with: message)
                    }
                } else {
                    MessageViewAlert.showSuccess(with: message ?? Validation.Error.genericError.rawValue)
                }
            })
           }
        }
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func scanAction() {
        guard let authUser = AuthUser.getAuthUser() else {
            return
        }
        if authUser.type == .serviceProvider {
            QRDisplayViewController.displayQR(on: self)
        } else {
            startScan()
        }
    }
}
extension HomeFeedsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkInFeed", for: indexPath) as! CheckInFeedTableViewCell
        cell.setupCell(with: feeds[indexPath.row])
        cell.userImageButton.tag = indexPath.row
        cell.userImageButton.addTarget(self, action: #selector(showUserProfileButtonsTap(button:)), for: .touchUpInside)
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(showFeedDetailButtonTap), for: .touchUpInside)
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        return cell
    }
}
extension HomeFeedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FeedDetailViewController.showFeedDetail(on: self.navigationController, feed: feeds[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchbar.resignFirstResponder()
    }
}

extension HomeFeedsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        SearchViewController.pushSearch(on: self.navigationController)
        return false
    }
}

extension HomeFeedsViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getSelectedViewModel().numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let story = getSelectedViewModel().cellForItemAt(indexPath: indexPath) else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IGAddStoryCell.reuseIdentifier, for: indexPath) as? IGAddStoryCell else { fatalError() }
            cell.userDetails = ("Add","")
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IGStoryListCell.reuseIdentifier,for: indexPath) as? IGStoryListCell else { fatalError() }
        cell.story = story
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let story = getSelectedViewModel().cellForItemAt(indexPath: indexPath) else {
            showWhoIFollow()
            return
        }
        DispatchQueue.main.async { [weak self] in
            if self?.followingMeButton.isSelected ?? false {
                let profileId = story.user.id
                if let tabbar = self?.tabBarController {
                    self?.chatManager.launchChatWith(contactId: profileId, from: tabbar, configuration: ALKConfiguration())
                }
            } else {
                let profileId = story.user.id
                PublicProfileViewController.showProfile(on: self?.navigationController, profileId: profileId)
            }
            /*if let stories = self.viewModel.getStories(), let stories_copy = try? stories.copy() {
                let storyPreviewScene = IGStoryPreviewController.init(stories: stories_copy, handPickedStoryIndex:  indexPath.row-1)
                self.present(storyPreviewScene, animated: true, completion: nil)
            }*/
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
