//
//  MapCenter.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/10/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

struct MapCenter {
    
    static var shared: MapCenter = MapCenter()
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}
