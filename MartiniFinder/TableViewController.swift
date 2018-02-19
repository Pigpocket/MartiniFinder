//
//  TableViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/3/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    // MARK: Properties

    var locations = [Location]()
    var favoriteLocation: Favorites?
    var locationManager = CLLocationManager()
    
    // MARK: Outlets
    
    @IBOutlet var locationsTableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = UIColor.black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3", MapCenter.shared.latitude, MapCenter.shared.longitude) { (locations, error) in
            
            if error != nil {
                print("There was an error: \(String(describing: error))")
            }
            
            performUIUpdatesOnMain {
                
                if let locations = locations {
                    self.locations = locations
                    self.locationsTableView.reloadData()
                }
            }
        }
    }

}

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! TableViewCell
        let location = locations[indexPath.row]
        
            YelpClient.sharedInstance().loadImage(location.imageUrl, completionHandler: { (image) in
                
                performUIUpdatesOnMain {
                    
                    cell.thumbnailImageView.layer.cornerRadius = 10
                    cell.thumbnailImageView.clipsToBounds = true
                    cell.thumbnailImageView.image = image
                    
                    //cell.nameLabel.sizeToFit()
                    cell.nameLabel.text = location.name
                    cell.priceLabel.text = location.price
                    cell.displayRating(location: location)
                }
                
                YelpClient.sharedInstance().getOpeningHoursFromID(id: location.id, completionHandlerForOpeningHours: { (isOpenNow, error) in
                    
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
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! TableViewCell
        cell.horizontalStackView.layoutIfNeeded()
        cell.horizontalStackView.sizeToFit()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! TableViewCell
        let cellSize = cell.horizontalStackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let cellHeight = cellSize.height
        print("cellHeight is: \(cellHeight)")
        
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = locations[indexPath.row]
        
        // Initialize NSManagedObject 'Location' with properties
        favoriteLocation = Favorites(context: CoreDataStack.sharedInstance().context)
        favoriteLocation?.name = location.name
        favoriteLocation?.isFavorite = true
        favoriteLocation?.id = location.id
        favoriteLocation?.latitude = location.latitude
        favoriteLocation?.longitude = location.longitude
        favoriteLocation?.price = location.price
        favoriteLocation?.rating = location.rating
        favoriteLocation?.imageUrl = location.imageUrl
        print("Changes to context: \(CoreDataStack.sharedInstance().context.hasChanges)")
        CoreDataStack.sharedInstance().saveContext()
        CoreDataStack.sharedInstance().save()

        
        // Get the Yelp URL of the location and segue to that in browser
        YelpClient.sharedInstance().getUrlFromLocationName(id: location.id) { (url, error) in

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
