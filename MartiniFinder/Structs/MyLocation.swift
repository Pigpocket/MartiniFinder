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
    
    //var coordinates = CLLocation(latitude: 0.0, longitude: 0.0)
    var myLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    func getDistance(latitude: Double, longitude: Double) -> String {

        let distanceInMeters = CLLocation(latitude: latitude, longitude: longitude).distance(from: myLocation)
        var distance = ""
        
        if distanceInMeters < 16093.4 {
            distance = String((distanceInMeters/1609).rounded(toPlaces: 1))
        } else {
            distance = String(format: "%.0f", (distanceInMeters/1609))
        }
        return distance
    }
}
