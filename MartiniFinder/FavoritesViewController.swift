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
        
        self.view.backgroundColor = UIColor.black
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! FavoritesTableViewCell

        // Get location NSManagedObject
        let location = self.fetchedResultsController.object(at: indexPath)
        let nameText = location.name!
        
        var size = CGSize()
        
        if let font = UIFont(name: ".SFUIText", size: 17.0) {
            let fontAttributes = [NSAttributedStringKey.font: font]
            size = (nameText).size(withAttributes: fontAttributes)
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
                
                cell.backgroundColor = UIColor.black
                
                cell.thumbnailImageView.layer.cornerRadius = 10
                cell.thumbnailImageView.clipsToBounds = true
                cell.thumbnailImageView.layer.borderColor = UIColor.white.cgColor
                cell.thumbnailImageView.layer.borderWidth = 1
                cell.thumbnailImageView.image = image
                
                cell.nameLabel.text = favorite.name
                cell.nameLabel.textColor = UIColor.white
                
                cell.priceLabel.text = favorite.price
                cell.priceLabel.textColor = UIColor.white
                
                cell.displayRating(rating: favorite.rating)
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
                        cell.openLabel.textColor = UIColor.white
                    } else {
                        cell.openLabel.text = "Closed"
                        cell.openLabel.textColor = UIColor(red: 195/255, green: 89/255, blue: 75/255, alpha: 1.0)
                        cell.openLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
                    }
                }
            }
        })
        return cell
    }
}
