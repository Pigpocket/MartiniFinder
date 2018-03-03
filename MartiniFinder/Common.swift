//
//  Common.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/2/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {

    func configureTextColor(_ rating: Double) -> UIColor {
        
        var color = UIColor()
        
        if rating <= 1.5 {
            color = UIColor(red: 242/255.0, green: 189/255.0, blue: 121/255.0, alpha: 1)
        } else if rating > 1.5 && rating <= 2.5 {
            color = UIColor(red: 254/255.0, green: 192/255.0, blue: 15/255.0, alpha: 1)
        } else if rating > 2.5 && rating <= 3.5 {
            color = UIColor(red: 255/255.0, green: 146/255.0, blue: 65/255.0, alpha: 1)
        } else if rating > 3.5 && rating <= 4.5 {
            color = UIColor(red: (241/255.0), green: (92/255.0), blue: (79/255.0), alpha: 1)
        } else if rating > 4.5 {
            color = UIColor(red: (211/255.0), green: (36/255.0), blue: (34/255.0), alpha: 1)
        }
        print("This is the color: \(color)")
        return color
    }
}
