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
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate  {
    
    // MARK: Properties
    
    var annotationArray: [CustomAnnotation] = []
    var locationManager = CLLocationManager()
    let singleTap = UITapGestureRecognizer()
    var tappedLocation: Location?
    var timer: Timer?

    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var redoSearchButton: UIButton!
    @IBOutlet weak var resetLocationButton: UIButton!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var blankView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var horizontalStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        activityIndicator.isHidden = true
        
        configureTabBar()
        configureLocationView()
        configureResetLocationButton()
        configureRedoSearchButton()
        configureGestureRecognizers()

        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 200
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: Actions
    
    @IBAction func resetLocation(_ sender: Any) {
        self.setMapRegion()
        resetLocationButton.isHidden = true
        redoSearchButton.isHidden = false
    }
    
    @IBAction func redoSearch(_ sender: Any) {
        
        locationView.isHidden = true
        redoSearchButton.isHidden = true
        Location.sharedInstance.removeAll()

        MapCenter.shared.latitude = mapView.centerCoordinate.latitude
        MapCenter.shared.longitude = mapView.centerCoordinate.longitude

        getLocations()
    }
    
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

