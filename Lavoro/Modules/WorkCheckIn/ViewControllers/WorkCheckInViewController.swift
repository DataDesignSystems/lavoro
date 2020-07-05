//
//  WorkCheckInViewController.swift
//  Lavoro
//
//  Created by Manish on 02/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import GooglePlaces

class WorkCheckInViewController: BaseViewController {
    @IBOutlet weak var gradientTopView: UIView!
    @IBOutlet weak var gradientBottomView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var selectLocationButton: UIButton!
    @IBOutlet weak var charLimitLabel: UILabel!
    let profileService = ProfileService()
    let placeholderText = "Say something..."
    var selectedPlace: GMSPlace?
    
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
        if AuthUser.getAuthUser()?.isAlreadyCheckIn() ?? false {
            checkInButton.setTitle("Check Out And Notify", for: .normal)
            checkInButton.backgroundColor = UIColor(hexString: "#FF2D55")
            selectLocationButton.setTitle(AuthUser.getAuthUser()?.placeName, for: .normal)
            selectLocationButton.isUserInteractionEnabled = false
        } else {
            checkInButton.setTitle("Check In And Notify", for: .normal)
            checkInButton.backgroundColor = UIColor(hexString: "#4CD964")
            selectLocationButton.isUserInteractionEnabled = true
        }
        charLimitLabel.text = "0/\(AppPrefrences.messageCharLimit)"
    }
    
    @IBAction func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInNotify() {
        let tagline = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard tagline.count > 0 else {
            return
        }
        let isCheckIn = !(AuthUser.getAuthUser()?.isAlreadyCheckIn() ?? false)
        var googleId = ""
        if isCheckIn {
            guard let place = selectedPlace, let placeId = place.placeID else {
                MessageViewAlert.showError(with: Validation.ValidationError.selectPlace.rawValue)
                return
            }
            googleId = placeId
        } else {
            googleId = AuthUser.getAuthUser()?.placeId ?? ""
        }
        self.showLoadingView()
        
        profileService.updateCheckInStatus(with: tagline, place_id: googleId, isCheckIn: isCheckIn) { [weak self] (success, message) in
            self?.stopLoadingView()
            if success {
                if let message = message {
                    MessageViewAlert.showSuccess(with: message)
                }
                AuthUser.getAuthUser()?.toggleCheckInStatus(with: self?.selectedPlace?.name ?? "", placeId: self?.selectedPlace?.placeID ?? "")
                if let tabbar = self?.appDelegate.window?.rootViewController as? TabbarViewController {
                    tabbar.setupCheckInStatusText()
                }
                self?.closeButtonAction()
                
            } else {
                MessageViewAlert.showError(with: message ?? "There is some error./nPlease try again")
            }
        }
    }
    
    @IBAction func selectLocation() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        /*
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "MyWorkLocationsViewController") as! MyWorkLocationsViewController
        viewController.isOpenedAsBottomSheet = true
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
        present(bottomSheet, animated: true, completion: nil)*/
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension WorkCheckInViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        selectedPlace = place
        selectLocationButton.setTitle(place.name, for: .normal)
        viewController.dismiss(animated: true, completion: nil)
        print(viewController)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(viewController)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
        print(viewController)
    }
}

extension WorkCheckInViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        if let textViewString = textView.text, let swtRange = Range(range, in: textViewString) {
            let fullString = textViewString.replacingCharacters(in: swtRange, with: text)
            if fullString.count <= AppPrefrences.messageCharLimit {
                charLimitLabel.text = "\(fullString.count)/\(AppPrefrences.messageCharLimit)"
                return true
            } else {
                textView.text = fullString[0..<AppPrefrences.messageCharLimit]
                charLimitLabel.text = "\(AppPrefrences.messageCharLimit)/\(AppPrefrences.messageCharLimit)"
                return false
            }
            
        }

        return true
    }
}
