//
//  LocationManager.swift
//  Buddy4
//
//  Created by Manish on 04/04/20.
//  Copyright © 2020 Asbjørn Rørvik. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    public static let shared = LocationManager()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    private override init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func stopLocation() {
        locationManager.stopUpdatingHeading()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentCoordinate = locations.first?.coordinate {
            currentLocation = currentCoordinate
        }
    }
}
