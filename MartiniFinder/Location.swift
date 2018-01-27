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

    // MARK: Properties
    
    var latitude = 0.0
    var longitude = 0.0
    var isClosed = 0
    var price = ""
    var name = ""
    var rating = 0.0
    var distance = 0.0
    var imageUrl = ""
    
    // MARK: Initializer
    init?(dictionary: [String:AnyObject]) {
        
        // GUARD: Do all dictionaries have values?
        guard
            let name = dictionary[YelpClient.ParameterValues.Name] as? String,
            let rating = dictionary[YelpClient.ParameterValues.Rating] as? Double,
            let price = dictionary[YelpClient.ParameterValues.Price] as? String,
            let isClosed = dictionary[YelpClient.ParameterValues.IsClosed] as? Int,
            let distance = dictionary[YelpClient.ParameterValues.Distance] as? Double,
            let coordinates = dictionary[YelpClient.ParameterKeys.Coordinates] as? [String:Any],
            let latitude = coordinates[YelpClient.ParameterValues.Latitude] as? Double,
            let longitude = coordinates[YelpClient.ParameterValues.Longitude] as? Double,
            let imageUrl = dictionary[YelpClient.ParameterValues.ImageUrl] as? String
            
            // If not, return nil
            else { return nil }
        
            // Otherwise, initialize values
            self.name = name
            self.rating = rating
            self.price = price
            self.isClosed = isClosed
            self.distance = distance
            self.latitude = latitude
            self.longitude = longitude
            self.imageUrl = imageUrl
        }
    
    static func locationFromResults(_ results: [[String:AnyObject]]) -> [Location] {
        
        var locations = [Location]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            if let location = Location(dictionary: result) {
                locations.append(location)
            }
        }
        return locations
    }
    
    
}
    


