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
    
    static var sharedInstance: [Location] = [Location]()

    // MARK: Properties
    
    var id = ""
    var latitude = 0.0
    var longitude = 0.0
    var isOpenNow = false
    var price = ""
    var name = ""
    var rating = 0.0
    var imageUrl = ""
    var image: UIImage? = nil
    var reviewCount: Int = 0
    
    // MARK: Initializer
    init?(dictionary: [String:AnyObject]) {
        
        // GUARD: Do all dictionaries have values?
        guard
            let id = dictionary[YelpClient.ParameterValues.id] as? String,
            let name = dictionary[YelpClient.ParameterValues.name] as? String,
            let rating = dictionary[YelpClient.ParameterValues.rating] as? Double,
            let price = dictionary[YelpClient.ParameterValues.price] as? String,
            let coordinates = dictionary[YelpClient.ParameterKeys.coordinates] as? [String:Any],
            let latitude = coordinates[YelpClient.ParameterValues.latitude] as? Double,
            let longitude = coordinates[YelpClient.ParameterValues.longitude] as? Double,
            let imageUrl = dictionary[YelpClient.ParameterValues.imageUrl] as? String,
            let reviewCount = dictionary[YelpClient.ParameterValues.reviewCount] as? Int
            
            // If not, return nil
            else { return nil }
        
            // Otherwise, initialize values
            self.id = id
            self.name = name
            self.rating = rating
            self.price = price
            self.latitude = latitude
            self.longitude = longitude
            self.imageUrl = imageUrl
            self.reviewCount = reviewCount
        }

    static func locationFromResults(_ results: [[String:AnyObject]]) -> [Location] {

        return results.flatMap(Location.init)
    }

}
    


