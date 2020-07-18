//
//  BlacklistViewController.swift
//  Lavoro
//
//  Created by Manish on 18/07/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import ApplozicSwift

class BlacklistViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    var users = [OtherUser]()
    var searchController = UISearchController(searchResultsController: nil)
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "You not followed by anyone!\nPlease check later"
        label.textColor = UIColor(white: 0.20, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    var loadingUsers = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        self.navigationItem.searchController = searchController
        setupView()
    }
    
    func setupView() {
        tableview.backgroundView = UIView()
        tableview.backgroundView?.addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
        }
        searchController.searchBar.delegate = self
    }
    
    func fetchData() {
        noDataLabel.isHidden = true
        if users.count == 0 {
            self.showLoadingView()
        }
        userService.getMyBlacklist { [weak self] (success, message, users) in
            self?.stopLoadingView()
            self?.noDataLabel.isHidden = !users.isEmpty
            self?.users = users
            self?.tableview.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesSearchBarWhenScrolling = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension BlacklistViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blacklistCell", for: indexPath) as! BlacklistTableViewCell
        cell.setupCell(with: users[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileId = users[indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        if let tabbar = self.tabBarController {
            self.chatManager.launchChatWith(contactId: profileId, from: tabbar, configuration: ALKConfiguration())
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if header == nil {
            header = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
            header?.backgroundColor = .white
            header?.tintColor = .white
            let title: UILabel = UILabel()
            title.textColor = .black
            title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            title.tag = 11
            header?.addSubview(title)
            title.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview().offset(4)
                make.leading.equalTo(16)
            }
        }
        if let label = header?.viewWithTag(11) as? UILabel {
            label.text = users.count > 0 ? "Following Me".uppercased() : ""
        }
        return header
    }
}

extension BlacklistViewController: UISearchControllerDelegate {
    
}
extension BlacklistViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        SearchViewController.pushSearch(on: self.navigationController)
        return false
    }
}
extension BlacklistViewController: ChangeFollowStatus {
    func apiCallInitiated(userId: Int) {
        loadingUsers.append("\(userId)")
    }
    
    func apiCallEnd(userId: Int, success: Bool) {
        if let index = loadingUsers.firstIndex(of: "\(userId)") {
            loadingUsers.remove(at: index)
        }
        if success {
            for user in users {
                if user.id == "\(userId)" {
                    user.isBlacklist.toggle()
                }
            }
            tableview.reloadData()
        }
    }
    
}

