//
//  AddScheduleViewController.swift
//  Lavoro
//
//  Created by Manish on 10/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class AddScheduleViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var createEventButton: UIButton!
    
    var addScheduleTypes = [AddScheduleType(type: .location, value: "Please Select"),
                            AddScheduleType(type: .date, value: "Please Select"),
                            AddScheduleType(type: .startEndTime, value: "Please Select")]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        createEventButton.setLayer(cornerRadius: 4)
        createEventButton.isEnabled = false
    }
}

extension AddScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return addScheduleTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addScheduleImage", for: indexPath) as! AddScheduleImageTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addScheduleData", for: indexPath) as! AddScheduleDataTableViewCell
            cell.setupCell(with: addScheduleTypes[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 236
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "MyWorkLocationsViewController") as! MyWorkLocationsViewController
                viewController.isOpenedAsBottomSheet = true
                let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
                present(bottomSheet, animated: true, completion: nil)
            default:
                print("not handled")
            }
        }
    }
}
