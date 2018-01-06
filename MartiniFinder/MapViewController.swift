//
//  MapViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/5/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
import UIKit
import MapKit
import Foundation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    let annotation = MKPointAnnotation()
    let annotationArray: [MKPointAnnotation] = []
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
    }
    
    
}
