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
            print("Find martinis pressed")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

