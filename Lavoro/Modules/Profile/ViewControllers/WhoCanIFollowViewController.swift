//
//  WhoCanIFollowViewController.swift
//  Lavoro
//
//  Created by Manish on 06/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class WhoCanIFollowViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    var users = OtherUser.mockdata()
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesSearchBarWhenScrolling = false
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
extension WhoCanIFollowViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedRail", for: indexPath) as! RecommendedCollectionTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as! FollowTableViewCell
        cell.setupCell(with: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 76
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
            
            let seeAllButton: UIButton = UIButton()
            seeAllButton.setTitle("See all", for: .normal)
            seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            seeAllButton.setTitleColor(UIColor(hexString: "FF2D55"), for: .normal)
            seeAllButton.tag = 12
            header?.addSubview(seeAllButton)
            seeAllButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(title)
                make.trailing.equalToSuperview().offset(-16)
            }

        }
        if let label = header?.viewWithTag(11) as? UILabel {
            if section == 0 {
                label.text = "Recommended".uppercased()
            } else {
                label.text = "Service Professionals".uppercased()
            }
        }
        if let button = header?.viewWithTag(12) {
            if section == 0 {
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
        return header
    }
}

extension WhoCanIFollowViewController: UISearchControllerDelegate {
    
}
