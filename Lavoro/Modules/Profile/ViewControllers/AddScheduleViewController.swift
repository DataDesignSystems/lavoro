//
//  AddScheduleViewController.swift
//  Lavoro
//
//  Created by Manish on 10/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import GooglePlaces

protocol AddScheduleDelegate: class {
    func schedulaeAdded()
}

class AddScheduleViewController: BaseViewController {
    @IBOutlet weak var gradientTopView: UIView!
    @IBOutlet weak var gradientBottomView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var deleteEntryButton: UIButton!
    @IBOutlet weak var charLimitLabel: UILabel!
    @IBOutlet weak var selectLocationButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    let scheduleService = ScheduleService()
    let placeholderText = "Say something..."
    var selectedPlace: GMSPlace?
    var selectedStartDate: Date = Date()
    var selectedEndDate: Date = Date()
    var delegate: AddScheduleDelegate?
    var event: ScheduleEvent?
    
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
        charLimitLabel.text = "0/\(AppPrefrences.messageCharLimit)"
        setupExistingData()
    }
    
    func setupExistingData() {
        guard let event = event else {
            return
        }
        self.selectedEndDate = event.endTime
        self.selectedStartDate = event.startTime
        self.endTimeButton.setTitle(event.endTime.toString(dateFormat: "MM-dd-yyyy hh:mm a"), for: .normal)
        self.startTimeButton.setTitle(event.startTime.toString(dateFormat: "MM-dd-yyyy hh:mm a"), for: .normal)
        self.selectLocationButton.setTitle(event.locationText, for: .normal)
        self.message.text = event.message
        self.charLimitLabel.text = "\(event.message.count)/\(AppPrefrences.messageCharLimit)"
        self.deleteEntryButton.isHidden = false
    }
    
    @IBAction func selectLocation() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func selectStartTime() {
        RPicker.selectDate(title: "Select Start Date", cancelText: "Cancel", datePickerMode: .dateAndTime, selectedDate: selectedStartDate, didSelectDate: { [weak self] (selectedDate) in
            self?.selectedStartDate = selectedDate
            self?.startTimeButton.setTitle(selectedDate.toString(dateFormat: "MM-dd-yyyy hh:mm a"), for: .normal)
        })
    }
    
    @IBAction func selectEndTime() {
        RPicker.selectDate(title: "Select End Date", cancelText: "Cancel", datePickerMode: .dateAndTime, selectedDate: selectedEndDate, didSelectDate: { [weak self] (selectedDate) in
            self?.selectedEndDate = selectedDate
            self?.endTimeButton.setTitle(selectedDate.toString(dateFormat: "MM-dd-yyyy hh:mm a"), for: .normal)
        })
    }
    
    @IBAction func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInNotify() {
        let messageToSend = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard messageToSend.count > 0 else {
            return
        }
        guard selectedStartDate < selectedEndDate else {
            MessageViewAlert.showError(with: Validation.Error.startEndTime.rawValue)
            return
        }
        var googleId = event?.googleId
        if googleId == nil {
            guard let place = selectedPlace, let placeId = place.placeID else {
                MessageViewAlert.showError(with: Validation.ValidationError.selectPlace.rawValue)
                return
            }
            googleId = placeId
        }
        guard let placeId = googleId else {
            MessageViewAlert.showError(with: Validation.ValidationError.selectPlace.rawValue)
            return
        }
        self.showLoadingView()
        scheduleService.addToMyCalendar(with: messageToSend, startTime: selectedStartDate, endTime: selectedEndDate, placeId: placeId, calendarId: event?.calendarId) { [weak self] (success, message) in
            self?.stopLoadingView()
            if success {
                if let message = message {
                    self?.delegate?.schedulaeAdded()
                    MessageViewAlert.showSuccess(with: message)
                }
                self?.closeButtonAction()
            } else {
                MessageViewAlert.showError(with: message ?? "There is some error./nPlease try again")
            }
        }
    }
    
    @IBAction func deleteEntryButtonTap() {
        guard let calendarId = event?.calendarId else {
            return
        }
        self.showLoadingView()
        scheduleService.removeFromMyCalendar(with: calendarId) { [weak self] (success, message) in
            if success {
                if let message = message {
                    self?.delegate?.schedulaeAdded()
                    MessageViewAlert.showSuccess(with: message)
                }
                self?.closeButtonAction()
            } else {
                MessageViewAlert.showError(with: message ?? "There is some error./nPlease try again")
            }
        }
    }
}

extension AddScheduleViewController: UITextViewDelegate {
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
extension AddScheduleViewController: GMSAutocompleteViewControllerDelegate {
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
extension AddScheduleViewController {
    static func showEditSchedule(presentingView: UIViewController ,event: ScheduleEvent, delegate: AddScheduleDelegate) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
        viewController.event = event
        viewController.delegate = delegate
        presentingView.present(viewController, animated: true, completion: nil)
    }
}
