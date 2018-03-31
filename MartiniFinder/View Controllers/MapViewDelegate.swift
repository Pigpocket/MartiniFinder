//
//  MapViewDelegate.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/31/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        tappedLocation = nil
        horizontalStackViewHeightConstraint.constant = 96
        thumbnailImageView.image = nil
        nameLabel.text = ""
        priceLabel.text = ""
        openLabel.text = ""
        distanceLabel.text = ""
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        if let annotationView = annotationView {
            
            for location in Location.sharedInstance {
                if annotationView.annotation?.coordinate.latitude == location.latitude && annotationView.annotation?.coordinate.longitude == location.longitude {
                    if location.rating < 2 {
                        annotationView.image = UIImage(named: "1star")
                    } else if location.rating == 2 || location.rating == 2.5 {
                        annotationView.image = UIImage(named: "2star")
                    } else if location.rating == 3.0 || location.rating == 3.5 {
                        annotationView.image = UIImage(named: "3star")
                    } else if location.rating == 4.0 || location.rating == 4.5 {
                        annotationView.image = UIImage(named: "4star")
                    } else if location.rating > 4.5 {
                        annotationView.image = UIImage(named: "5star")
                    }
                }
            }
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation as? CustomAnnotation
        
        // Add the tapped location to the tappedLocation array
        for location in Location.sharedInstance {
            if location.latitude == annotation?.coordinate.latitude && location.longitude == annotation?.coordinate.longitude {
                tappedLocation = location
            }
        }
        
        if let tappedLocation = tappedLocation {
            
            YelpClient.sharedInstance().getOpeningHoursFromID(id: tappedLocation.id, completionHandlerForOpeningHours: { (isOpenNow, error) in
                
                if error != nil {
                    print("There was an error getting business hours: \(String(describing: error))")
                }
                
                performUIUpdatesOnMain {
                    if isOpenNow == true {
                        self.openLabel.text = "Open"
                        self.openLabel.textColor = UIColor.white
                    } else {
                        self.openLabel.text = "Closed"
                        let rating = tappedLocation.rating
                        if rating <= 1.5 {
                            self.openLabel.textColor = YelpColor.shared.lowColor
                        } else if rating > 1.5 && rating <= 2.5 {
                            self.openLabel.textColor = YelpColor.shared.lowMedColor
                        } else if rating > 2.5 && rating <= 3.5 {
                            self.openLabel.textColor = YelpColor.shared.medColor
                        } else if rating > 3.5 && rating <= 4.5 {
                            self.openLabel.textColor = YelpColor.shared.medHighColor
                        } else if rating > 4.5 {
                            self.openLabel.textColor = YelpColor.shared.highColor
                        }
                        self.openLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
                    }
                    self.locationView.isHidden = false
                }
            })
            
            // Remove non-breaking space in attempt to have nameLabel word wrap correctly
            let locationNameStripped = tappedLocation.name.replacingOccurrences(of: " ", with: "")
            self.nameLabel.text = locationNameStripped //self.tappedLocation[0].name
            self.nameLabel.textColor = UIColor.white
            
            self.priceLabel.text = tappedLocation.price
            self.priceLabel.textColor = UIColor.white
            
            self.displayRating(location: tappedLocation)
            
            self.thumbnailImageView.image = tappedLocation.image
            
            self.horizontalStackView.addBackground(color: UIColor.black)
            self.horizontalStackViewHeightConstraint.constant = self.viewHeight(tappedLocation.name)
            
            let distance = MyLocation.shared.getDistance(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude)
            self.distanceLabel.text = "\(distance) miles"
            self.distanceLabel.textColor = UIColor.white
        }
    }
    
    func setMapRegion() {
        
        // Set the coordinates
        let coordinates = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
}
