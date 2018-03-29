//
//  NavBarItem.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/28/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "yelp"))
        imageView.contentMode = .scaleAspectFit
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
    }
}
