//
//  LocationManagerDelegate.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/31/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension MapViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error getting your location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            
            guard locationManager.location != nil else {
                
                let alertController = UIAlertController(title: NSLocalizedString("Geolocation Error", comment: ""), message: NSLocalizedString("We were unable to find your location. Please try again", comment: ""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in self.backToHome() })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            MapCenter.shared.latitude = (locationManager.location?.coordinate.latitude)!
            MapCenter.shared.longitude = (locationManager.location?.coordinate.longitude)!
            MyLocation.shared.myLocation = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            
            getLocations()
            setMapRegion()
            
        } else if status == .denied {
            let alertController = UIAlertController(title: NSLocalizedString("Location Services Disabled", comment: ""), message: NSLocalizedString("This application requires location services to be enabled", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: { _ in self.backToHome() })
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
}
