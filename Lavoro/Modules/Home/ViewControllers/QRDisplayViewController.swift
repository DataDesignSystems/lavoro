//
//  QRDisplayViewController.swift
//  Lavoro
//
//  Created by Manish on 28/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import QRCodeReader

protocol QRDisplayDelegate {
    func userAdded()
}

class QRDisplayViewController: BaseViewController {
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var qrCodeImage: UIImageView!
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton = true
            $0.showOverlayView = true
            $0.cancelButtonTitle = ""
            let readerView = QRCodeReaderContainer(displayable: ScannerOverlay())
            $0.readerView = readerView
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    let homeService: HomeService = HomeService()
    var delegate: QRDisplayDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        self.showLoadingView()
        homeService.getQRCode { [weak self] (success, message, qrImage) in
            self?.stopLoadingView()
            if success, let url = URL(string: qrImage ?? "") {
                self?.qrCodeImage.sd_setImage(with: url, completed: nil)
            } else {
                MessageViewAlert.showError(with: message ?? Validation.Error.genericError.rawValue)
                self?.closeButtonAction()
            }
        }
    }
    
    func setupView() {
        scanButton.setLayer(cornerRadius: 4)
    }
    
    @IBAction func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanStartButton() {
        readerVC.completionBlock = { [weak self] (result: QRCodeReaderResult?) in
           self?.readerVC.dismiss(animated: true) { [weak self] in
            guard let value = result?.value else {
                return
            }
            self?.showLoadingView()
            self?.homeService.followUserByQR(qrCode: value, completionHandler: { [weak self] (success, message) in
                self?.stopLoadingView()
                if success {
                    if let message = message, message.count > 0 {
                        self?.delegate?.userAdded()
                        MessageViewAlert.showSuccess(with: message)
                    }
                } else {
                    MessageViewAlert.showSuccess(with: message ?? Validation.Error.genericError.rawValue)
                }
            })
           }
        }
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
}
extension QRDisplayViewController {
    static func displayQR(on viewController: UIViewController?, delegate: QRDisplayDelegate) {
        guard let presentOnViewController = viewController else {
            return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "QRDisplayViewController") as! QRDisplayViewController
        viewController.delegate = delegate
        presentOnViewController.present(viewController, animated: true) {
        }
    }
}
