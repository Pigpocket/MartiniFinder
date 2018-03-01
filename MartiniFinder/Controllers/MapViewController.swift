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
    var tappedLocation = [Location]()

    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var redoSearchButton: UIButton!
    @IBOutlet weak var resetLocationButton: UIButton!
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var blankView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!

    @IBOutlet weak var horizontalStackViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItem()
        
        // Stylize tabBar
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.isTranslucent = false
        
        // Stylize locationView
        locationView.isHidden = true
        locationView.layer.cornerRadius = 10
        locationView.layer.borderColor = UIColor.black.cgColor
        locationView.layer.borderWidth = 1
        locationView.layer.shadowRadius = 1.5
        locationView.layer.shadowColor = UIColor(red: 195/255, green: 89/255, blue: 75/255, alpha: 1.0).cgColor
        locationView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        locationView.layer.shadowOpacity = 0.9
        locationView.layer.masksToBounds = false
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderColor = UIColor.white.cgColor
        thumbnailImageView.layer.borderWidth = 1
        
        // Configure resetLocationButton
        resetLocationButton.isHidden = true
        resetLocationButton.contentHorizontalAlignment = .fill
        resetLocationButton.contentVerticalAlignment = .fill
        resetLocationButton.contentMode = .scaleAspectFit
        
        // Configure redoSearchButton
        redoSearchButton.isHidden = true
        redoSearchButton.layer.cornerRadius = 10
        redoSearchButton.layer.cornerRadius = 10
        redoSearchButton.layer.borderColor = UIColor.black.cgColor
        redoSearchButton.layer.borderWidth = 1
        redoSearchButton.layer.shadowRadius = 1.5
        redoSearchButton.layer.shadowColor = UIColor(red: 195/255, green: 89/255, blue: 75/255, alpha: 1.0).cgColor
        redoSearchButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        redoSearchButton.layer.shadowOpacity = 0.9
        redoSearchButton.layer.masksToBounds = false
        
        // Declare gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap(_:)))
        panGesture.delegate = self
        
        // Add gesture recognizers to view
        mapView.addGestureRecognizer(tapGesture)
        mapView.addGestureRecognizer(panGesture)
        
        // Get user position
        MapCenter.shared.latitude = (locationManager.location?.coordinate.latitude)!
        MapCenter.shared.longitude = (locationManager.location?.coordinate.longitude)!
        
        // Get locations
        getLocations()
        
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
 
    func setAnnotations() {
        
        // Set the coordinates
        for location in Location.sharedInstance {
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
    
    func viewHeight(_ locationName: String) -> CGFloat {
        
        let locationName = tappedLocation[0].name
        
        var size = CGSize()
        
        if let font = UIFont(name: ".SFUIText", size: 17.0) {
            let fontAttributes = [NSAttributedStringKey.font: font]
            size = (locationName as NSString).size(withAttributes: fontAttributes)
        }
        
        let normalCellHeight = horizontalStackViewHeightConstraint.constant
        let extraLargeCellHeight = horizontalStackViewHeightConstraint.constant + 20.33
        
        let textWidth = ceil(size.width)
        let cellWidth = ceil(nameLabel.frame.width)
        
        if textWidth > cellWidth {
            print("XL cell. Width: \(nameLabel.frame.width)")
            print("Text width: \(textWidth)")
            return extraLargeCellHeight
        } else {
            print("Normal cell. Width: \(nameLabel.frame.width)")
            print("Text width: \(textWidth)")
            return normalCellHeight
        }
    }
    
    @objc func handleSingleTap(sender: UIGestureRecognizer) {
        tappedLocation.removeAll()
        singleTap.numberOfTapsRequired = 1
        locationView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        tappedLocation.removeAll()
        horizontalStackViewHeightConstraint.constant = 96
        thumbnailImageView.image = nil
        nameLabel.text = ""
        priceLabel.text = ""
        openLabel.text = ""
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        annotation = view.annotation as! MKPointAnnotation
        
        // Add the tapped location to the tappedLocation array
        for location in Location.sharedInstance {
            if location.latitude == annotation.coordinate.latitude && location.longitude == annotation.coordinate.longitude {
                tappedLocation.append(location)
            }
        }
                        
        if tappedLocation[0].isOpenNow {
            self.openLabel.text = "Open"
            self.openLabel.textColor = UIColor.white
        } else {
            self.openLabel.text = "Closed"
            self.openLabel.textColor = UIColor(red: 195/255, green: 89/255, blue: 75/255, alpha: 1.0)
            self.openLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        }
        
        self.nameLabel.text = self.tappedLocation[0].name
        self.nameLabel.textColor = UIColor.white
        
        self.priceLabel.text = self.tappedLocation[0].price
        self.priceLabel.textColor = UIColor.white
        
        self.displayRating(location: self.tappedLocation[0])
        self.thumbnailImageView.image = self.tappedLocation[0].image
        
        self.horizontalStackView.addBackground(color: UIColor.black)
        self.horizontalStackViewHeightConstraint.constant = self.viewHeight(self.tappedLocation[0].name)

        locationView.isHidden = false
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
        
        Location.sharedInstance.removeAll()

        MapCenter.shared.latitude = mapView.centerCoordinate.latitude
        MapCenter.shared.longitude = mapView.centerCoordinate.longitude
        
        // Get locations
        getLocations()

    }
    
    func getLocations() {
        
        // Get locations
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3,4", MapCenter.shared.latitude, MapCenter.shared.longitude) { (locations, error) in
            
            if error != nil {
                print("There was an error: \(String(describing: error))")
            }
            
            performUIUpdatesOnMain {
                
                if let locations = locations {
                    Location.sharedInstance = locations
                    
                    for i in 0..<Location.sharedInstance.count {
                        YelpClient.sharedInstance().loadImage(Location.sharedInstance[i].imageUrl, completionHandler: { (image) in
                            
                            Location.sharedInstance[i].image = image
                            
                            YelpClient.sharedInstance().getOpeningHoursFromID(id: Location.sharedInstance[i].id, completionHandlerForOpeningHours: { (isOpenNow, error) in
                                
                                if error != nil {
                                    print("There was an error getting business hours: \(String(describing: error))")
                                }
                                
                                if isOpenNow {
                                    
                                    Location.sharedInstance[i].isOpenNow = isOpenNow
                                }
                            })
                        })
                    }
                }
                
                // Create the annotations
                var tempArray = [MKPointAnnotation]()
                
                for dictionary in Location.sharedInstance {
                    
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
    }

    func displayRating(location: Location) {
        
        if location.rating == 1 {
            star1.image = UIImage(named: "regular_1")
        } else if location.rating == 1.5 {
            star1.image = UIImage(named: "regular_1_half")
        } else if location.rating == 2 {
            star1.image = UIImage(named: "regular_2")
        } else if location.rating == 2.5 {
            star1.image = UIImage(named: "regular_2_half")
        } else if location.rating == 3.0 {
            star1.image = UIImage(named: "regular_3")
        } else if location.rating == 3.5 {
            star1.image = UIImage(named: "regular_3_half")
        } else if location.rating == 4.0 {
            star1.image = UIImage(named: "regular_4")
        } else if location.rating == 4.5 {
            star1.image = UIImage(named: "regular_4_half")
        } else if location.rating == 5.0 {
            star1.image = UIImage(named: "regular_5")
        }
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

extension UIViewController {
    func setNavigationItem() {
        print("setNavigationItem called")
        let imageView = UIImageView(image: UIImage(named: "yelp"))
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
    }
}
