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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate  {
    
    // MARK: Properties
    
    var annotation = MKPointAnnotation()
    var annotationArray: [MKPointAnnotation] = []
    var locationManager = CLLocationManager()
    var locations = [Location]()
    let singleTap = UITapGestureRecognizer()
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var horizontalStack: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalStack.isHidden = true
        imageView.backgroundColor = UIColor.red
        ratingImage.backgroundColor = UIColor.red
        imageView.layer.cornerRadius = 10
        horizontalStack.addBackground(color: UIColor.white)
        
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        
        // 2. add the gesture recognizer to a view
        mapView.addGestureRecognizer(tapGesture)
    
    
    // 3. this method is called when a tap is recognized
    func handleTap(sender: UITapGestureRecognizer) {
        print("tap")
    }
        
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3", 33.7064016, -116.397167) { (locations, error) in
            
            if error != nil {
                print("There was an error: \(String(describing: error))")
            }
            
            performUIUpdatesOnMain {
                
            if let locations = locations {
                self.locations = locations
                print("These are locations in MapViewController: \(locations)")
            }
            
            var tempArray = [MKPointAnnotation]()
            
            for dictionary in self.locations {
                
                let lat = CLLocationDegrees(dictionary.latitude)
                let long = CLLocationDegrees(dictionary.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                // Set the image
                let imageUrl = dictionary.imageUrl
                let url = URL(fileURLWithPath: imageUrl)
                if let imageData = try? Data(contentsOf: url) {
                    let image = UIImage(data: imageData)
                    self.imageView.image = image
                }
                
                let name = dictionary.name
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(name)"
                tempArray.append(annotation)
            }
            
            // Add the annotations to the annotations array
            self.mapView.removeAnnotations(self.annotationArray)
            self.annotationArray = tempArray
            self.mapView.addAnnotations(self.annotationArray)
        }
        }
        
        self.mapView.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("My latitude is: \(String(describing: locationManager.location?.coordinate.latitude))")
            print("My longitude is: \(String(describing: locationManager.location?.coordinate.longitude))")
        }
        
        setMapRegion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func setAnnotations() {
        
        // Set the coordinates
        for location in self.locations {
            let annotation = MKPointAnnotation()
            
            let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.coordinate = coordinates
            mapView.addAnnotation(annotation)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is MKPinAnnotationView)
    }
    
    @objc func handleSingleTap(sender: UIGestureRecognizer) {
        print("Recognizing the single tap")
        singleTap.numberOfTapsRequired = 1
        horizontalStack.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
        print("didSelect was pressed")
        //view.annotation = annotation
        horizontalStack.isHidden = false
        populateStackViews(annotation: view.annotation as! MKPointAnnotation)
        
    }
    
    func populateStackViews(annotation: MKPointAnnotation) {
        for location in locations {
            if location.latitude == annotation.coordinate.latitude && location.longitude == annotation.coordinate.longitude {
                nameLabel.text = location.name
                priceLabel.text = location.price
                if location.isClosed == 0 {
                    openLabel.text = "open"
                } else {
                    openLabel.text = "closed"
                    openLabel.textColor = UIColor.red
                }
                
            }
        }
    }
    
    func setMapRegion() {
        
        // Set the coordinates
        let coordinates = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        print("Coordinates are: \(coordinates)")
        
        let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        self.mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
    
    
}

extension UIStackView {
    
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = 10
        insertSubview(subView, at: 0)
    }
    
}
