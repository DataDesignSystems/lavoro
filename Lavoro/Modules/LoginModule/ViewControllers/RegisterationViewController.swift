//
//  RegisterationViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class RegisterationViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var user = User()
    var textFieldPlacehoders = ["Username", "Password", "Email", "Phone", "Gender", "Date of birth"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func imageSelectionButton(button: UIButton) {
        self.openImagePicker()
    }
    
    override func imageSelectedFromPicker(image: UIImage) {
        user.image = image
        tableView.reloadData()
    }
    
    @IBAction func saveButtonAction() {
        appDelegate.presentUserFLow()
    }
}
extension RegisterationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + textFieldPlacehoders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerationImageCell", for: indexPath) as! RegisterationImageTableViewCell
            if let image = user.image {
                cell.imageSelectionButton.setBackgroundImage(image, for: .normal)
                cell.imageSelectionButton.setImage(nil, for: .normal)
            }
            cell.imageSelectionButton.addTarget(self, action: #selector(imageSelectionButton(button:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerationTextCell", for: indexPath) as! RegisterationTextTableViewCell
            cell.textField.placeholder = textFieldPlacehoders[indexPath.row - 1]
            return cell
        }
    }
}
extension RegisterationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 260
        }
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
