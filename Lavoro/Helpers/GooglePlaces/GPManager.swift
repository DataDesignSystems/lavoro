//
//  GPManager.swift
//  Lavoro
//
//  Created by Manish on 25/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import GooglePlaces

class GPManager {
    static var key = "AIzaSyDx7C5HSITI1Hg1Y2JvCr421qE1Y3nICoU"
    
    static func imageUrlString(with photoID: String) -> String {
        return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(Int(UIScreen.main.bounds.width))&photoreference=\(photoID)&key=API_KEY"
    }
    
    static func findNearbyPlaces(completionHandler: @escaping ((Bool, [WorkLocation]) -> ())) {
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))!
        GMSPlacesClient.shared().findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                completionHandler(false, [])
                return
            }
            var workLocations = [WorkLocation]()
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList {
                    workLocations.append(WorkLocation(with: likelihood.place))
                    let place = likelihood.place
                    print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
                    print("Current PlaceID \(String(describing: place.placeID))")
                }
            }
            completionHandler(true, workLocations)
        })
        
    }
}
