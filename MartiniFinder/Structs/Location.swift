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
    
    //Better to make things let constants (same for all these)
    let id: String
    var latitude = 0.0
    var longitude = 0.0
    var isOpenNow = false
    var price = ""
    var name = ""
    var rating = 0.0
    var distance = 0.0
    var imageUrl = ""
    var image: UIImage? = nil
    
    // MARK: Initializer
    //This could also throw an exception instead of returning nil (I think that form is slightly preferred these days)
    init?(dictionary: [String:AnyObject]) {
        
        // GUARD: Do all dictionaries have values?
        guard
            let id = dictionary[YelpClient.ParameterValues.Id] as? String,
            let name = dictionary[YelpClient.ParameterValues.Name] as? String,
            let rating = dictionary[YelpClient.ParameterValues.Rating] as? Double,
            let price = dictionary[YelpClient.ParameterValues.Price] as? String,
            let distance = dictionary[YelpClient.ParameterValues.Distance] as? Double,
            let coordinates = dictionary[YelpClient.ParameterKeys.Coordinates] as? [String:Any],
            let latitude = coordinates[YelpClient.ParameterValues.Latitude] as? Double,
            let longitude = coordinates[YelpClient.ParameterValues.Longitude] as? Double,
            let imageUrl = dictionary[YelpClient.ParameterValues.ImageUrl] as? String
            
            // If not, return nil
            else { return nil }
        
            // Otherwise, initialize values
            self.id = id
            self.name = name
            self.rating = rating
            self.price = price
            //self.isOpenNow = isOpenNow
            self.distance = distance
            self.latitude = latitude
            self.longitude = longitude
            self.imageUrl = imageUrl
        }

    static func locationFromResults(_ results: [[String:AnyObject]]) -> [Location] {
        //This is a really compact way of writing the below
        return results.flatMap(Location.init)
//        var locations = [Location]()
//
//        // iterate through array of dictionaries, each Movie is a dictionary
//        for result in results {
//            if let location = Location(dictionary: result) {
//                locations.append(location)
//            }
//        }
//        return locations
    }

}
    


