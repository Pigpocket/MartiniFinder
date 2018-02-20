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
    
    // Initialize FetchedResultsController
    
    lazy var fetchedResultsController: NSFetchedResultsController<Favorites> = { () -> NSFetchedResultsController<Favorites> in
        
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance().context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // Outlets
    
    @IBOutlet var favoritesTableView: UITableView!
    
    // MARK : Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]

        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            // delete item at indexPath
            print("Swipe to delete")
            
            // Get favorites from Core Data
            let favorite = self.fetchedResultsController.object(at: indexPath)

            CoreDataStack.sharedInstance().context.delete(favorite)
            CoreDataStack.sharedInstance().saveContext()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

        }
        return [delete]
    }
    
    // MARK: Manage index path count for table view
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
        case NSFetchedResultsChangeType.delete:
            print("trying to delete")
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
        case NSFetchedResultsChangeType.update:
            print("trying to update")
            tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesTableViewCell

        let favorite = self.fetchedResultsController.object(at: indexPath)
        
        // Asynchronously load object data
        YelpClient.sharedInstance().loadImage(favorite.imageUrl, completionHandler: { (image) in
            
            performUIUpdatesOnMain {
                cell.thumbnailImageView.layer.cornerRadius = 10
                cell.thumbnailImageView.clipsToBounds = true
                cell.thumbnailImageView.image = image
                
                cell.nameLabel.text = favorite.name
                cell.priceLabel.text = favorite.price
                cell.displayRating(location: favorite)
                cell.thumbnailImageView.image = image
            }
        })
        
        // Set isOpenNow
        YelpClient.sharedInstance().getOpeningHoursFromID(id: favorite.id!, completionHandlerForOpeningHours: { (isOpenNow, error) in
            
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
        return cell
    }
}
