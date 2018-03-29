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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // Stylize tabBar
        self.tabBarController?.setNavigationItem()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.isTranslucent = false
        
        // Configure locationView
        locationView.isHidden = true
        locationView.layer.cornerRadius = 10
        locationView.layer.borderColor = UIColor.black.cgColor
        locationView.layer.borderWidth = 1
        locationView.layer.shadowRadius = 1.5
        locationView.layer.shadowColor = UIColor(red: 195/255, green: 89/255, blue: 75/255, alpha: 1.0).cgColor
        locationView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        locationView.layer.shadowOpacity = 0.9
        locationView.layer.masksToBounds = false
        locationView.isUserInteractionEnabled = true
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.borderColor = UIColor.white.cgColor
        thumbnailImageView.layer.borderWidth = 1
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width * 2
        
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
        
        // Request location access
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            // Get user position
            MapCenter.shared.latitude = (locationManager.location?.coordinate.latitude)!
            MapCenter.shared.longitude = (locationManager.location?.coordinate.longitude)!
            MyLocation.shared.myLocation = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            
            getLocations()
            setMapRegion()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error getting your location")
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
    
    func viewHeight(_ locationName: String) -> CGFloat {
        
        var locationName = String()
        
        if let tappedLocation = tappedLocation {
            locationName = tappedLocation.name
        }
        
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
            print("***\(locationName)***")
            print("XL cell. Width: \(nameLabel.frame.width)")
            print("Text width: \(textWidth)")
            return extraLargeCellHeight
        } else {
            print("***\(locationName)***")
            print("Normal cell. Width: \(nameLabel.frame.width)")
            print("Text width: \(textWidth)")
            return normalCellHeight
        }
    }
    
    @objc func handleSingleTap(sender: UIGestureRecognizer) {
        tappedLocation = nil
        singleTap.numberOfTapsRequired = 1
        locationView.isHidden = true
    }
    
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
                //MyLocation.shared.myLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                print("Added location: \(location) \n")
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
                            self.openLabel.textColor = UIColor(red: 242/255.0, green: 189/255.0, blue: 121/255.0, alpha: 1)
                        } else if rating > 1.5 && rating <= 2.5 {
                            self.openLabel.textColor = UIColor(red: 254/255.0, green: 192/255.0, blue: 15/255.0, alpha: 1)
                        } else if rating > 2.5 && rating <= 3.5 {
                            self.openLabel.textColor = UIColor(red: 255/255.0, green: 146/255.0, blue: 65/255.0, alpha: 1)
                        } else if rating > 3.5 && rating <= 4.5 {
                            self.openLabel.textColor = UIColor(red: 241/255.0, green: 92/255.0, blue: 79/255.0, alpha: 1)
                        } else if rating > 4.5 {
                            self.openLabel.textColor = UIColor(red: 211/255.0, green: 36/255.0, blue: 34/255.0, alpha: 1)
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
    
    @IBAction func resetLocation(_ sender: Any) {
        setMapRegion()
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
        let imageView = UIImageView(image: UIImage(named: "yelp"))
        imageView.contentMode = .scaleAspectFit
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
    }
}
