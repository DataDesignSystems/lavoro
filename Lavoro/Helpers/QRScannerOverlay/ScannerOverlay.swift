//
//  ScannerOverlay.swift
//  Lavoro
//
//  Created by Manish on 28/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import UIKit
import QRCodeReader

class ScannerOverlay: UIView, QRCodeReaderDisplayable {
    public lazy var overlayView: QRCodeReaderViewOverlay? = {
        let ov = ReaderOverlayView()
        ov.backgroundColor = .clear
        ov.defaultColor = UIColor(hexString: "#FF2D55")
        ov.clipsToBounds = true
        return ov
    }()
    
    public let cameraView: UIView = {
        let cv = UIView()
        cv.clipsToBounds = true
        return cv
    }()
    
    public lazy var cancelButton: UIButton? = {
        let cb = UIButton()
        cb.setImage(UIImage(named: "ic_close_bg"), for: .normal)
        cb.setTitle("", for: .normal)
        return cb
    }()
    
    public var switchCameraButton: UIButton?
    
    public var toggleTorchButton: UIButton?
    
    private weak var reader: QRCodeReader?
    
    public func setupComponents(with builder: QRCodeReaderViewControllerBuilder) {
        self.reader               = builder.reader
        
        addComponents()
        
        cancelButton?.isHidden       = !builder.showCancelButton
        overlayView?.isHidden        = !builder.showOverlayView
        
        cameraView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if builder.showCancelButton {
            cancelButton?.snp.makeConstraints({ (make) in
                make.leading.top.equalTo(16.0)
                make.width.height.equalTo(40)
            })
        }
        cancelButton?.setTitle("", for: .normal)
        if let overlayView = overlayView {
            overlayView.snp.makeConstraints { (make) in
                make.leading.top.equalTo(80)
                make.leading.equalTo(24)
                make.centerX.equalToSuperview()
                make.height.equalTo(overlayView.snp.width)
            }
        }
        self.overlayView?.setState(.normal)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        reader?.previewLayer.frame = bounds
    }
    
    // MARK: - Scan Result Indication
    
    func startTimerForBorderReset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.overlayView?.setState(.normal)
        }
    }
    
    func addRedBorder() {
        self.startTimerForBorderReset()
        
        self.overlayView?.setState(.wrong)
    }
    
    func addGreenBorder() {
        self.startTimerForBorderReset()
        
        self.overlayView?.setState(.valid)
    }
    
    @objc public func setNeedsUpdateOrientation() {
        setNeedsDisplay()
        overlayView?.setNeedsDisplay()
    }
    
    // MARK: - Convenience Methods
    
    private func addComponents() {
        #if swift(>=4.2)
        let notificationName = UIDevice.orientationDidChangeNotification
        #else
        let notificationName = NSNotification.Name.UIDeviceOrientationDidChange
        #endif
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNeedsUpdateOrientation), name: notificationName, object: nil)
        
        addSubview(cameraView)
        
        if let ov = overlayView {
            addSubview(ov)
        }
        
        if let scb = switchCameraButton {
            addSubview(scb)
        }
        
        if let ttb = toggleTorchButton {
            addSubview(ttb)
        }
        
        if let cb = cancelButton {
            addSubview(cb)
        }
        
        if let reader = reader {
            cameraView.layer.insertSublayer(reader.previewLayer, at: 0)
            
            setNeedsUpdateOrientation()
        }
    }
}

