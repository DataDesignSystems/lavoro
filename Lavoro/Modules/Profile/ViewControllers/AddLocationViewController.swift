//
//  AddLocationViewController.swift
//  Lavoro
//
//  Created by Manish on 10/05/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableview: UITableView!
    var locations: [WorkLocation] = WorkLocation.mockData()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLocation() {
        let location = MKPointAnnotation()
        if let coordinate = LocationManager.shared.currentLocation {
            location.coordinate = coordinate
            mapView.addAnnotation(location)
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(viewRegion, animated: false)
            mapView.selectAnnotation(location, animated: true)
        }
    }
}

extension AddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addLocationCell", for: indexPath) as! AddLocationTableViewCell
            cell.nameCenterYConstraint.constant = 0
            cell.addressLabel.isHidden = true
            cell.nameLabel.text = "Use my current location"
            cell.locationImage.image = UIImage(named: "currentLocation")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "addLocationCell", for: indexPath) as! AddLocationTableViewCell
        cell.nameCenterYConstraint.constant = -16
        cell.addressLabel.isHidden = false
        cell.setupCell(with: locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
