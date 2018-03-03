//
//  CustomPointAnnotation.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/2/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation : MKPointAnnotation {
    var pinCustomImageName = "star1"
    //var coordinate: CLLocationCoordinate2D
    //var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, pinCustomImageName: String) {
        super.init()
        
        self.coordinate = coordinate
        self.title = title
        self.pinCustomImageName = pinCustomImageName
    }
    
}
