//
//  DoubleRounding.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/28/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
