//
//  GetLocations.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/31/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

extension MapViewController {
    
    func getLocations() {
        
        activityIndicator.isHidden = false
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.black
        activityIndicator.startAnimating()
        
        // Get locations
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3,4", MapCenter.shared.latitude, MapCenter.shared.longitude) { (locations, error) in
            
            if error != nil {
                self.showAlert(title: "Network Error", msg: (error)!)
            }
            
            performUIUpdatesOnMain {
                
                if let locations = locations {
                    Location.sharedInstance = locations
                    
                    for i in 0..<Location.sharedInstance.count {
                        YelpClient.sharedInstance().loadImage(Location.sharedInstance[i].imageUrl, completionHandler: { (image) in
                            
                            Location.sharedInstance[i].image = image
                            
                        })
                    }
                }
                
                // Create the annotations
                var tempArray = [CustomAnnotation]()
                
                for dictionary in Location.sharedInstance {
                    
                    let lat = CLLocationDegrees(dictionary.latitude)
                    let long = CLLocationDegrees(dictionary.longitude)
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let name = dictionary.name
                    let annotation = CustomAnnotation(coordinates: coordinates, title: name)
                    tempArray.append(annotation)
                    
                }
                
                // Add the annotations to the annotations array
                self.mapView.removeAnnotations(self.annotationArray)
                self.annotationArray = tempArray
                self.mapView.addAnnotations(self.annotationArray)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
}
