//
//  WorkLocation.swift
//  Lavoro
//
//  Created by Manish on 05/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

struct WorkLocation {
    var name: String
    var category: [String]
    var address: String
    var workingType: WorkingType = .working
    var location: CLLocationCoordinate2D
    var distance: Double
    var imageName: String
    var photoData: GMSPlacePhotoMetadata?
    var color: UIColor?
    var workingText: String?

    static func mockData() -> [WorkLocation] {
        return []
    }
    
    init(with place: GMSPlace) {
        self.name = place.name ?? ""
        self.category = []
        self.address = place.formattedAddress ?? ""
        self.workingType = .working
        self.location = place.coordinate
        self.distance = 10
        self.imageName = ""
        if let photo = place.photos?.first {
            self.photoData = photo
            
        }
    }
    
    init(name: String, category: [String], address: String, workingType: WorkingType, location: CLLocationCoordinate2D, distance: Double, imageName: String) {
        self.name = name
        self.category = category
        self.address = address
        self.workingType = workingType
        self.location = location
        self.distance = distance
        self.imageName = imageName
    }
    
    init(with json:[String: Any]) {
        self.name = json["name"] as? String ?? ""
        self.category = json["categories"] as? [String] ?? []
        
        let address = json["address"] as? String ?? ""
        let suite = json["suite"] as? String ?? ""
        let city = json["city"] as? String ?? ""
        let state = json["state"] as? String ?? ""
        let zip = json["zip"] as? String ?? ""
        
        self.address = address + " " + suite + " " + city + " " + state + " " + zip
        self.location = CLLocationCoordinate2D(latitude: json["latitude"] as? Double ?? 0.0, longitude: json["longitude"] as? Double ?? 0.0)
        self.distance = 0.0
        self.imageName = json["image"] as? String ?? ""
        if let working = json["working"] as? [String: Any] {
            self.workingText = working["name"] as? String ?? ""
            self.color = UIColor(hexString: working["color"] as? String) 
        } else {
            self.workingText = "Not Working"
            self.color = UIColor(hexString: "FF2D55")
        }
    }
}

enum WorkingType: String {
    case working = "Working"
    case notWorking = "Not Working"
}
