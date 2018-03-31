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

    var favoriteLocation: Favorites?
    var locationManager = CLLocationManager()
    
    // MARK: Outlets
    
    @IBOutlet var locationsTableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.isTranslucent = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationsTableView.reloadData()
    }

}


