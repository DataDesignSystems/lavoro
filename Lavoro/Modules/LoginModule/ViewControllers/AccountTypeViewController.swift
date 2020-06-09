//
//  AccountTypeViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit

class AccountTypeViewController: BaseViewController {
    let accountType = [AccountType(imageName: "customer", title: "CUSTOMER"),
                       AccountType(imageName: "serviceProfessional", title: "SERVICE PROFESSIONAL")]
    @IBOutlet weak var cancelButton: UIButton!
    let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let prefix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "000000")]
        let suffix = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor(hexString: "FF2D55")]
        let string = NSMutableAttributedString(string: "I am not interested in registering. ", attributes: prefix)
        string.append(NSMutableAttributedString(string: "Cancel", attributes: suffix))
        cancelButton.setAttributedTitle(string, for: .normal)
    }
    
    @IBAction func cancelButtonTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func continueButton(button: UIButton) {
        self.accuntTypeSelected(item: button.tag)
    }
    
    func accuntTypeSelected(item: Int) {
        showLoadingView()
        loginService.updateUserAccountType(with: "\(item+2)") { [weak self] (success, message) in
            self?.stopLoadingView()
            if success {
                self?.performSegue(withIdentifier: "showRegisterationPage", sender: self)
            } else {
                if message?.isEmpty ?? true {
                    MessageViewAlert.showError(with: Validation.Error.loginError.rawValue)
                } else {
                    MessageViewAlert.showError(with: message ?? "")
                }
            }
        }
    }
}

extension AccountTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountTypeCell", for: indexPath) as! AccountTypeTableViewCell
        cell.setupCell(with: accountType[indexPath.row])
        cell.continueButton.tag = indexPath.row
        cell.continueButton.addTarget(self, action: #selector(continueButton(button:)), for: .touchUpInside)
        return cell
    }
}
extension AccountTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
