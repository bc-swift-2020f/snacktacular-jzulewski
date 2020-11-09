//
//  SpotTableViewCell.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/2/20.
//

import UIKit
import CoreLocation

class SpotTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var currentLocation: CLLocation!
    var spot: Spot! {
        didSet {
            nameLabel.text = spot.name
            ratingLabel.text = "Avg. Rating: \(spot.averageRating)"
            
            guard let currentLocation = currentLocation else {
                distanceLabel.text = "Distance: -.-"
                return
            }
            let distanceInMeters = spot.location.distance(from: currentLocation)
            let distanceInMiles = ((distanceInMeters * 0.0062137) * 10).rounded() / 10
            distanceLabel.text = "Distance: \(distanceInMiles) miles"
        }
    }
    
}
