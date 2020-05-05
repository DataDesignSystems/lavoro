//
//  WorkLocation.swift
//  Lavoro
//
//  Created by Manish on 05/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import CoreLocation

struct WorkLocation {
    var name: String
    var category: CategoryType
    var address: String
    var workingType: WorkingType
    var location: CLLocationCoordinate2D
    var distance: Double
    var imageName: String
    
    static func mockData() -> [WorkLocation] {
        return [WorkLocation(name: "Anderson Pub & Grill", category: .restaurants, address: "8060 Beechmont Ave, Cincinnati, OH 45255", workingType: .working, location: CLLocationCoordinate2D(), distance: 5, imageName: "locationDummyImage"),
                WorkLocation(name: "Latitudes Bar & Bistro", category: .restaurants, address: "7454 Beechmont Ave, Cincinnati, OH 45255", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 8, imageName: "locationDummyImage"),
                WorkLocation(name: "Butterbee's American Grille", category: .restaurants, address: "5980 Meijer Dr, Milford, OH 45150", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 12, imageName: "locationDummyImage"),
                WorkLocation(name: "Butterbee's American Grille", category: .hotels, address: "5980 Meijer Dr, Milford, OH 45150", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 12, imageName: "locationDummyImage"),
                WorkLocation(name: "Anderson Pub & Grill", category: .hotels, address: "8060 Beechmont Ave, Cincinnati, OH 45255", workingType: .working, location: CLLocationCoordinate2D(), distance: 5, imageName: "locationDummyImage"),
                WorkLocation(name: "Latitudes Bar & Bistro", category: .other, address: "7454 Beechmont Ave, Cincinnati, OH 45255", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 8, imageName: "locationDummyImage"),
                WorkLocation(name: "Butterbee's American Grille", category: .other, address: "5980 Meijer Dr, Milford, OH 45150", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 12, imageName: "locationDummyImage"),
                WorkLocation(name: "Anderson Pub & Grill", category: .bars, address: "8060 Beechmont Ave, Cincinnati, OH 45255", workingType: .working, location: CLLocationCoordinate2D(), distance: 5, imageName: "locationDummyImage"),
                WorkLocation(name: "Latitudes Bar & Bistro", category: .bars, address: "7454 Beechmont Ave, Cincinnati, OH 45255", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 8, imageName: "locationDummyImage"),
                WorkLocation(name: "Latitudes Bar & Bistro", category: .bars, address: "7454 Beechmont Ave, Cincinnati, OH 45255", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 8, imageName: "locationDummyImage"),
                WorkLocation(name: "Latitudes Bar & Bistro", category: .other, address: "7454 Beechmont Ave, Cincinnati, OH 45255", workingType: .notWorking, location: CLLocationCoordinate2D(), distance: 8, imageName: "locationDummyImage")]
    }
}

enum WorkingType: String {
    case working = "Working"
    case notWorking = "Not Working"
}
