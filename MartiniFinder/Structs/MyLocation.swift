//
//  MyLocation.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/28/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import CoreLocation

struct MyLocation {
    
    static var shared = MyLocation()
    
    var coordinates = CLLocation(latitude: 0.0, longitude: 0.0)
    var myLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    func getDistance() -> Double {

        let distanceInMeters = myLocation.distance(from: coordinates)
        let distance = (distanceInMeters/1609).rounded(toPlaces: 1)
        
        return distance
    }
}
