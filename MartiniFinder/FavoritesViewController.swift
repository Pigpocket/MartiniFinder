//
//  FavoritesViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/12/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // Properties
    
    var favorites: [Favorites]!
    
    // Initialize FetchedResultsController
    
    lazy var fetchedResultsController: NSFetchedResultsController<Favorites> = { () -> NSFetchedResultsController<Favorites> in
        
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // Outlets
    
    @IBOutlet var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesTableViewCell
        
        let favorite = self.fetchedResultsController.object(at: indexPath)
        
        YelpClient.sharedInstance().loadImage(favorite.imageUrl, completionHandler: { (image) in
            
            performUIUpdatesOnMain {
                cell.thumbnailImageView.layer.cornerRadius = 10
                cell.thumbnailImageView.clipsToBounds = true
                cell.thumbnailImageView.image = image
                
                cell.nameLabel.text = favorite.name
                cell.priceLabel.text = favorite.price
                
//                if location.isClosed == 0 {
//                    cell.openLabel.text = "Open"
//                } else {
//                    cell.openLabel.text = "Closed"
//                    cell.openLabel.textColor = UIColor.red
//                }
                
                cell.displayRating(location: favorite)
            }
        })
        
        return cell
    }
}
