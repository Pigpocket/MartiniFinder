//
//  TableViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/3/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Properties

    var locations = [Location]()
    
    // MARK: Outlets
    
    @IBOutlet var locationsTableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3", 33.7064016, -116.397167) { (locations, error) in
            
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
        
        performUIUpdatesOnMain {
            
        cell.nameLabel.text = location.name
        cell.priceLabel.text = location.price
        
        if location.isClosed == 0 {
            cell.openLabel.text = "Open"
        } else {
            cell.openLabel.text = "Closed"
            cell.openLabel.textColor = UIColor.red
        }
        
        if let url = URL(string: location.imageUrl) {
            if let imageData = try? Data(contentsOf: url) {
                let image = UIImage(data: imageData)
                cell.thumbnailImageView.layer.cornerRadius = 10
                cell.thumbnailImageView.clipsToBounds = true
                cell.thumbnailImageView.image = image
            }
        }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = locations[indexPath.row]
        
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
