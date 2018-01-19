//
//  ViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/4/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var myMartiniBarsOutlet: UIButton!
    
    // MARK: Actions
    
    @IBAction func findMartinisAction(_ sender: Any) {
        YelpClient.sharedInstance().getYelpSearchResults("Martini", "1,2,3", 34.151722199942853, -118.2860258849463) { (success, error) in
            
            if error != nil {
                print("There was an error: \(String(describing: error))")
            }
            
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
}

