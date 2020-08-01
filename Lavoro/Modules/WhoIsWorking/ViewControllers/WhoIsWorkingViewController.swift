//
//  WhoIsWorkingViewController.swift
//  Lavoro
//
//  Created by Manish on 01/08/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class WhoIsWorkingViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    var searchController = UISearchController(searchResultsController: nil)
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "No one is working on selected date!"
        label.textColor = UIColor(white: 0.20, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    var loadingUsers = [String]()
    let whoIsWorkingService = WhoIsWorkingService()
    var selectedDate = Date()
    var workArray = [WhoIsWorking]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        self.navigationItem.searchController = searchController
        setupView()
    }
    
    func fetchData() {
        if workArray.count == 0 {
            self.showLoadingView()
        }
        noDataLabel.isHidden = true
        whoIsWorkingService.getWhosWorkingListByDate(with: selectedDate) { [weak self] (success, message, workArray)  in
            self?.stopLoadingView()
            self?.noDataLabel.isHidden = !workArray.isEmpty
            self?.workArray = workArray
            self?.tableview.reloadData()
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    @IBAction func selectDate() {
        RPicker.selectDate(title: "Select Date", cancelText: "Cancel", doneText: "Update", selectedDate: selectedDate, maxDate: Date(), didSelectDate: { [weak self] (selectedDate) in
            self?.workArray.removeAll()
            self?.selectedDate = selectedDate
            self?.fetchData()
            self?.tableview.reloadData()
        })
    }
}
extension WhoIsWorkingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WhoIsWorkingTableViewCell
        cell.setupCell(with: workArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
            title.textColor = UIColor(hexString: "#F80102")
            title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            title.tag = 11
            header?.addSubview(title)
            title.text = selectedDate.toString(dateFormat: "MMMM dd'\(selectedDate.daySuffix())' yyyy")
            title.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview().offset(4)
                make.leading.equalTo(16)
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else {
            return
        }
        PublicProfileViewController.showProfile(on: navigationController, profileId: workArray[indexPath.row].userId)
    }
}

extension WhoIsWorkingViewController: UISearchControllerDelegate {
    
}
extension WhoIsWorkingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        SearchViewController.pushSearch(on: self.navigationController)
        return false
    }
}
extension Date {
    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "ST"
        case 2, 22:
            return "ND"
        case 3, 23:
            return "RD"
        default:
            return "TH"
        }
    }
}
