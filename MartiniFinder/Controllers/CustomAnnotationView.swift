//
//  CustomAnnotationView.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/2/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Annotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var image: UIImage?
    
    init(coordinates location: CLLocationCoordinate2D, title: String, image: UIImage) {
        super.init()
        
        self.coordinate = location
        self.title = title
        self.image = image

    }
}
