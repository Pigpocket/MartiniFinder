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
    
    var favorites: [Favorites]?
    var favorite: Favorites!
    
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
        
//        let count = fetchCountFor(entityName: "Favorites", onMoc: CoreDataStack.sharedInstance().context)
//        print("Count is \(count)")
        
        //return count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            

        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            // delete item at indexPath
            print("Swipe to delete")
            
            self.tableView.beginUpdates()
            
            // Get favorites from Core Data
            let favorite = self.fetchedResultsController.object(at: indexPath)
            
            self.favorites?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            CoreDataStack.sharedInstance().context.delete(favorite)
            print("CoreDataStack has changes: \(CoreDataStack.sharedInstance().context.hasChanges)")
            CoreDataStack.sharedInstance().saveContext()
            self.tableView.endUpdates()
            
        }
        return [delete]
    }
    
    func fetchCountFor(entityName: String, onMoc moc: NSManagedObjectContext) -> Int {
        
        var count: Int = 0
        
        moc.performAndWait {
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            fetchRequest.resultType = NSFetchRequestResultType.countResultType
            
            do {
                count = try moc.count(for: fetchRequest)
            } catch {
                print("Error counting NSManagedObjects")
            }
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesTableViewCell
        
        // Get favorites from Core Data
//        let favoritesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
//
//        do {
//            let fetchedFavorites = try CoreDataStack.sharedInstance().context.fetch(favoritesFetch) as! [Favorites]
//            favorites = fetchedFavorites
//        } catch {
//            fatalError("Failed to fetch favorites: \(error)")
//        }
//
//        let favorite = favorites![indexPath.row]

        let favorite = self.fetchedResultsController.object(at: indexPath)
        
        // Asynchronously load object data
        YelpClient.sharedInstance().loadImage(favorite.imageUrl, completionHandler: { (image) in
            
            performUIUpdatesOnMain {
                cell.thumbnailImageView.layer.cornerRadius = 10
                cell.thumbnailImageView.clipsToBounds = true
                cell.thumbnailImageView.image = image
                
                cell.nameLabel.text = favorite.name
                cell.priceLabel.text = favorite.price
                cell.thumbnailImageView.image = image
                
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
