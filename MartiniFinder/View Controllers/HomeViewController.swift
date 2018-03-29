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
        navigationController?.additionalSafeAreaInsets = UIEdgeInsetsMake(-20, 0, 0, 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

