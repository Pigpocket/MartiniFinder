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
    
    //Don't need the type here
    static var shared = MapCenter()
    
    //or here (b/c its inferred)
    var latitude = 0.0
    var longitude = 0.0
}
