//
//  GestureRecognizerDelegate.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/31/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MapViewController {
    
    func configureGestureRecognizers() {
        
        // Declare gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        let didPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap(_:)))
        let willPanGesture = UIPanGestureRecognizer(target: self, action: #selector(willDragMap(_:)))
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewTap(_:)))
        
        // Assign delegates
        didPanGesture.delegate = self
        willPanGesture.delegate = self
        mapView.delegate = self
        
        // Add gesture recognizers to view
        mapView.addGestureRecognizer(tapGesture)
        mapView.addGestureRecognizer(didPanGesture)
        mapView.addGestureRecognizer(willPanGesture)
        locationView.addGestureRecognizer(viewTap)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is MKPinAnnotationView)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func viewTap(_ send: UITapGestureRecognizer) {
        
        if let tappedLocation = tappedLocation {
            
            // Get the Yelp URL of the location and segue to that in browser
            YelpClient.sharedInstance().getUrlFromLocationName(id: tappedLocation.id) { (url, error) in
                
                performUIUpdatesOnMain {
                    
                    if error != nil {
                        print("There was an error getting the URL")
                    }
                    
                    if let url = url {
                        let app = UIApplication.shared
                        app.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    @objc func willDragMap(_ gestureRecognizer: UIPanGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            redoSearchButton.isHidden = true
            resetLocationButton.isHidden = true
            locationView.isHidden = true
        }
    }
    
    @objc func didDragMap(_ gestureRecognizer: UIPanGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
                self.redoSearchButton.isHidden = false
                self.redoSearchButton.backgroundColor = UIColor.black
                self.resetLocationButton.isHidden = false
            }
        }
    }
    
    @objc func handleSingleTap(sender: UIGestureRecognizer) {
        tappedLocation = nil
        singleTap.numberOfTapsRequired = 1
        locationView.isHidden = true
    }
    
}
