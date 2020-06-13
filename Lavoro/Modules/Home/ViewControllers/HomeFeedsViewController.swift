//
//  HomeFeedsViewController.swift
//  Lavoro
//
//  Created by Manish on 01/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class HomeFeedsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIButton!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var storiesView: UIView!
    private var igStoriesView: IGHomeView!
    private var viewModel: IGHomeViewModel = IGHomeViewModel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.fetchData()
    }
    
    func fetchData() {
        self.showLoadingView()
        noFeedLabel.isHidden = true
        homeService.getDashboardData { [weak self] (success, message, feeds)  in
            self?.feeds = feeds
            self?.noFeedLabel.isHidden = !feeds.isEmpty
            self?.stopLoadingView()
            self?.tableView.reloadData()
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
        return cell
    }
}
extension HomeFeedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchbar.resignFirstResponder()
    }
}

extension HomeFeedsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeFeedsViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IGStoryListCell.reuseIdentifier,for: indexPath) as? IGStoryListCell else { fatalError() }
        let story = viewModel.cellForItemAt(indexPath: indexPath)
        cell.story = story
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
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
