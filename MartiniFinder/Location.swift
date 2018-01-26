//
//  Location.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/25/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

struct Location {
    
    static var shared: Location = Location()

    var latitude = 0.0
    var longitude = 0.0
    var isClosed = 0
    var price = ""
    var name = ""
    var rating = 0.0
    var distance = 0.0
}
