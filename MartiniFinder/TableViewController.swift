//
//  TableViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/3/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    // MARK: Properties

    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3", 33.7064016, -116.397167) { (locations, error) in
            
            if error != nil {
                print("There was an error: \(String(describing: error))")
            }
            
            performUIUpdatesOnMain {
                
                if let locations = locations {
                    self.locations = locations
                    print("These are locations in MapViewController: \(locations)")
                }
                
                for dictionary in self.locations {
                    
                    let name = dictionary.name
                    let rating = dictionary.rating
                    let price = dictionary.price
                    let distance = dictionary.distance
                    let isClosed = dictionary.isClosed

                }
            }
        }
    }

}
