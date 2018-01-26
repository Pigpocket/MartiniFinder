//
//  ViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/4/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Properties
    
    var locations = [Location]()
    
    // MARK: Outlets
    
    @IBOutlet weak var myMartiniBarsOutlet: UIButton!
    
    // MARK: Actions
    
    @IBAction func findMartinisAction(_ sender: Any) {
            
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "findMartinisSegue" {
//            let tabController = segue.destination as! UITabBarController
//            let navController = tabController.viewControllers![0] as! UINavigationController
//            let mapController = navController.viewControllers[0] as! MapViewController
//            mapController.locations = self.locations
//        }
//    }

}

