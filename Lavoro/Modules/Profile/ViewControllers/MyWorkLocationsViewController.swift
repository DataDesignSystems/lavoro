//
//  MyWorkLocationsViewController.swift
//  Lavoro
//
//  Created by Manish on 04/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import SnapKit

class MyWorkLocationsViewController: BaseViewController {
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collectionviewBackgroundView: UIView!
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var topTableHeaderConstraint: NSLayoutConstraint!
    var isOpenedAsBottomSheet = false

    var widthConstraint: Constraint?
    var leadingConstraint: Constraint?
    var selectedCategoryBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "FF2D55")
        return view
    }()

    var workLocations: [WorkLocation] = WorkLocation.mockData()
    var workCategories: [WorkCategories] = [WorkCategories(category: .all), WorkCategories(category: .restaurants), WorkCategories(category: .bars), WorkCategories(category: .hotels), WorkCategories(category: .other)]
    var selectedCategory: WorkCategories = WorkCategories(category: .all)
    var filteredWorkLocations = [WorkLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        filteredItems()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        collectionview.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionviewBackgroundView.gradientLayer(with: UIColor(white: 0, alpha: 0.0), endColor: UIColor(white: 0, alpha: 0.1))
        collectionview.addSubview(selectedCategoryBottomView)
        selectedCategoryBottomView.snp.makeConstraints { (make) in
            make.height.equalTo(3.0)
            leadingConstraint = make.leading.equalToSuperview().constraint
            widthConstraint = make.width.equalTo(32).constraint
            make.bottom.equalTo(collectionview.snp.bottom).offset(40)
        }
        if isOpenedAsBottomSheet {
            setupViewForBottomSheet()
        }
    }
    
    func setupViewForBottomSheet() {
        topHeaderView.isHidden = true
        topTableHeaderConstraint.constant = -102
    }
    
    func filteredItems(){
        guard selectedCategory.category != .all else {
            filteredWorkLocations = workLocations
            return
        }
        let filteredItems = workLocations.filter { workLocation in
            workLocation.category == selectedCategory.category
        }
        filteredWorkLocations = filteredItems
    }
}

extension MyWorkLocationsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        workCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workCategoriesCell", for: indexPath) as! WorkCategoriesCollectionViewCell
        cell.setupCell(with: workCategories[indexPath.item], selectedCategory: selectedCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = workCategories[indexPath.item]
        filteredItems()
        if let cell = collectionView.cellForItem(at: indexPath) {
            let width = Int(cell.width)
            widthConstraint?.update(offset: width)
            leadingConstraint?.update(offset: cell.frame.origin.x)
        }
        collectionView.reloadData()
        tableview.reloadData()
    }
}

extension MyWorkLocationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredWorkLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workLocationCell", for: indexPath) as! WorkLocationTableViewCell
        cell.setupCell(with: workLocations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
