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
    
    var annotation = MKPointAnnotation()
    var annotationArray: [MKPointAnnotation] = []
    var locationManager = CLLocationManager()
    var locations = [Location]()
    let singleTap = UITapGestureRecognizer()
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var horizontalStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var redoSearchButton: UIButton!
    @IBOutlet weak var resetLocationButton: UIButton!
    
    // imageViews
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var blankView: UIImageView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalStack.isHidden = true
        imageView.layer.cornerRadius = 10
        horizontalStack.addBackground(color: UIColor.white)
        self.tabBarController?.tabBar.tintColor = UIColor.black
        
        // Configure resetLocationButton & redoSearchButtons
        resetLocationButton.contentHorizontalAlignment = .fill
        resetLocationButton.contentVerticalAlignment = .fill
        resetLocationButton.contentMode = .scaleAspectFit
        resetLocationButton.layer.cornerRadius = 10
        resetLocationButton.isHidden = true
        
        redoSearchButton.layer.cornerRadius = 10
        redoSearchButton.isHidden = true
        
        // Add gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap(_:)))
        panGesture.delegate = self
        
        // Add gesture recognizers to a view
        mapView.addGestureRecognizer(tapGesture)
        mapView.addGestureRecognizer(panGesture)
        
        // Get user position
        MapCenter.shared.latitude = (locationManager.location?.coordinate.latitude)!
        MapCenter.shared.longitude = (locationManager.location?.coordinate.longitude)!
        
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3,4", MapCenter.shared.latitude, MapCenter.shared.longitude) { (locations, error) in
            
            if error != nil {
                print("There was an error: \(String(describing: error))")
            }
            
            performUIUpdatesOnMain {
                
            if let locations = locations {
                self.locations = locations
            }
            
            var tempArray = [MKPointAnnotation]()
            
            for dictionary in self.locations {
                
                let lat = CLLocationDegrees(dictionary.latitude)
                let long = CLLocationDegrees(dictionary.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
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
    
    func displayRating(location: Location) {
        
        if location.rating == 1 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "emptyStar")
            star3.image = UIImage(named: "emptyStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 1.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "halfStar")
            star3.image = UIImage(named: "emptyStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 2 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "emptyStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 2.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "halfStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 3.0 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 3.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "halfStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 4.0 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "filledStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 4.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "filledStar")
            star5.image = UIImage(named: "halfStar")
        } else if location.rating == 5.0 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "filledStar")
            star5.image = UIImage(named: "filledStar")
        }
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didDragMap(_ gestureRecognizer: UIPanGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            redoSearchButton.isHidden = false
            resetLocationButton.isHidden = false
        }
    }
    
    @objc func handleSingleTap(sender: UIGestureRecognizer) {
        singleTap.numberOfTapsRequired = 1
        horizontalStack.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        horizontalStack.isHidden = false
        populateStackViews(annotation: view.annotation as! MKPointAnnotation)
    }
    
    func populateStackViews(annotation: MKPointAnnotation) {
        for location in locations {
            if location.latitude == annotation.coordinate.latitude && location.longitude == annotation.coordinate.longitude {
                
                nameLabel.text = location.name
                priceLabel.text = location.price
                
                displayRating(location: location)
                
                // Set the image
                if let url = URL(string: location.imageUrl) {
                    if let imageData = try? Data(contentsOf: url) {
                        let image = UIImage(data: imageData)
                        self.imageView.layer.cornerRadius = 10
                        self.imageView.clipsToBounds = true
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    func setMapRegion() {
        
        // Set the coordinates
        let coordinates = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
    
    @IBAction func resetLocation(_ sender: Any) {
        setMapRegion()
    }
    
    @IBAction func redoSearch(_ sender: Any) {
        
        locations.removeAll()

        MapCenter.shared.latitude = mapView.centerCoordinate.latitude
        MapCenter.shared.longitude = mapView.centerCoordinate.longitude
        
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3,4", MapCenter.shared.latitude, MapCenter.shared.longitude, completionHandlerForSearchResults: { (locations, error) in
            
            if error != nil {
                print("There was an error: \(String(describing: error))")
            }
            
            performUIUpdatesOnMain {
                
                if let locations = locations {
                    self.locations = locations
                }
                
                var tempArray = [MKPointAnnotation]()
                
                for dictionary in self.locations {
                    
                    let lat = CLLocationDegrees(dictionary.latitude)
                    let long = CLLocationDegrees(dictionary.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
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
        })
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
