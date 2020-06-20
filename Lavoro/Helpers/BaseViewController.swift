//
//  BaseViewController.swift
//  Lavoro
//
//  Created by Manish on 30/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SnapKit
import IQKeyboardManagerSwift

class BaseViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userService = UserService()
    var activityIndicatorView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: UIColor(hexString: "#FF2D55"), padding: 12.0)
    let chatManager = ALChatManager(applicationKey: ALChatManager.applicationId)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.backgroundColor = UIColor(white: 0, alpha: 0.65)
        activityIndicatorView.setLayer(cornerRadius: 8.0)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        view.bringSubviewToFront(activityIndicatorView)
    }
    
    func addkeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }

    @IBAction func backButton () {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            if self.view.frame.origin.y != 0
            {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
    }
    
    @objc func openImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let GalleryAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            self.openGallery()
        }
        let CameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default ) { action -> Void in
            self.openCamera()
        }
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel ) { action -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(GalleryAction)
        alert.addAction(CameraAction)
        alert.addAction(CancelAction)
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect =  CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY / 2.5, width: 0, height: 0)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
        } else{
            //Alert(self,message: "Camera not available!")
        }
    }
    
    func  openGallery () {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imageSelectedFromPicker(image: UIImage) {
        
    }
}
extension BaseViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image : UIImage?
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = pickedImage
        }
        else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = pickedImage
        }
        if let image = image {
            self.imageSelectedFromPicker(image: image)
        }
        picker.dismiss(animated: true) {
            
        }
    }
}

extension BaseViewController {
    public func showLoadingView() {
        self.view.isUserInteractionEnabled = false
        self.activityIndicatorView.startAnimating()
        
    }
    public func stopLoadingView() {
        self.view.isUserInteractionEnabled = true
        self.activityIndicatorView.stopAnimating()
    }

}
