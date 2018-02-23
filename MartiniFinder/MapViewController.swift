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

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate  {
    
    // MARK: Properties
    
    var annotation = MKPointAnnotation()
    var annotationArray: [MKPointAnnotation] = []
    var locationManager = CLLocationManager()
    var locations = [Location]()
    let singleTap = UITapGestureRecognizer()
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var redoSearchButton: UIButton!
    @IBOutlet weak var resetLocationButton: UIButton!
    @IBOutlet weak var mapTableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.isTranslucent = false
        self.mapTableView.isHidden = true
        self.mapTableView.delegate = self
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell") as! MapTableViewCell
        //cell.horizontalStackView.isHidden = true
        cell.thumbnailImageView.layer.cornerRadius = 10
        cell.horizontalStackView.addBackground(color: UIColor.white)
        //cell.frame.size.width = tableView.frame.width
        
        // Get data
        var cellLocation: Location
        
        for location in locations {
            if location.latitude == annotation.coordinate.latitude && location.longitude == annotation.coordinate.longitude {
                cellLocation = location

        
        YelpClient.sharedInstance().loadImage(cellLocation.imageUrl, completionHandler: { (image) in
            
            performUIUpdatesOnMain {
                
                cell.thumbnailImageView.layer.cornerRadius = 10
                cell.thumbnailImageView.clipsToBounds = true
                cell.thumbnailImageView.image = image
                cell.nameLabel.text = cellLocation.name
                cell.priceLabel.text = cellLocation.price
                cell.displayRating(location: cellLocation)
            }
            
            YelpClient.sharedInstance().getOpeningHoursFromID(id: cellLocation.id, completionHandlerForOpeningHours: { (isOpenNow, error) in
                
                if let error = error {
                    print("There was an error: \(String(describing: error))")
                }
                
                if let isOpenNow = isOpenNow {
                    
                    performUIUpdatesOnMain {
                        
                        if isOpenNow {
                            cell.openLabel.text = "Open"
                            cell.openLabel.textColor = UIColor.black
                        } else {
                            cell.openLabel.text = "Closed"
                            cell.openLabel.textColor = UIColor.red
                        }
                    }
                }
            })
        })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell") as! MapTableViewCell
        
        let nameText = locations[indexPath.row].name
        
        var size = CGSize()
        
        if let font = UIFont(name: ".SFUIText", size: 17.0) {
            let fontAttributes = [NSAttributedStringKey.font: font]
            size = (nameText as NSString).size(withAttributes: fontAttributes)
        }
        
        let normalCellHeight = CGFloat(96)
        let extraLargeCellHeight = CGFloat(normalCellHeight + 20.33)
        
        let textWidth = ceil(size.width)
        let cellWidth = ceil(cell.nameLabel.frame.width)
        
        if textWidth > cellWidth {
            return extraLargeCellHeight
        } else {
            return normalCellHeight
        }
    }
    
    @objc func handleSingleTap(sender: UIGestureRecognizer) {
        singleTap.numberOfTapsRequired = 1
        mapTableView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapTableView.isHidden = false
        
        annotation = view.annotation as! MKPointAnnotation
        
        mapTableView.reloadData()
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
