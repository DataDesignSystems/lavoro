//
//  WorkCheckInViewController.swift
//  Lavoro
//
//  Created by Manish on 02/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class WorkCheckInViewController: UIViewController {
    @IBOutlet weak var gradientTopView: UIView!
    @IBOutlet weak var gradientBottomView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        gradientTopView.gradientLayer(with: UIColor(white: 0, alpha: 0.75), endColor: UIColor(white: 0, alpha: 0))
        gradientBottomView.gradientLayer(with: UIColor(white: 0, alpha: 0), endColor: UIColor(white: 0, alpha: 1))
        parentView.setLayer(cornerRadius: 8)
        userImage.setLayer(cornerRadius: 4)
        checkInButton.setLayer(cornerRadius: 4)
        if let url = URL(string: AuthUser.getAuthUser()?.avatar ?? "") {
            userImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    @IBAction func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInNotify() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectLocation() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "MyWorkLocationsViewController") as! MyWorkLocationsViewController
        viewController.isOpenedAsBottomSheet = true
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        present(bottomSheet, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
