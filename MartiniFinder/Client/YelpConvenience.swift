//
//  YelpConvenience.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/19/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

extension YelpClient {
    
    func getYelpSearchResults(_ term: String, _ price: String, _ latitude: Double, _ longitude: Double, completionHandlerForSearchResults: @escaping (_ locations: [Location]?, _ errorString: String?) -> Void) {
        
        let methods = Methods.Businesses + Methods.Search
        print("Methods are: \(methods)")
        
        let methodParameters = [
            ParameterKeys.Latitude: latitude,
            ParameterKeys.Longitude: longitude,
            ParameterKeys.OpenNow: true,
            ParameterKeys.Price: price,
            ParameterKeys.Radius: 16000,
            ParameterKeys.Term: term
            ] as [String : Any]
        
        taskForGetYelpSearchResults(method: methods, parameters: methodParameters as [String : AnyObject]) { (results, error) in
            
            if let error = error {
                completionHandlerForSearchResults(nil, "There was an error getting the images: \(error)")
            } else {
                if let results = results {
                    if let businesses = results["businesses"] as? [[String:AnyObject]] {
                        let locations = Location.locationFromResults(businesses)
                        completionHandlerForSearchResults(locations, nil)
                    } else {
                        completionHandlerForSearchResults(nil, "Unable to get array of locations")
                    }
                }
            }
        }
        

//                        for business in businesses {
                        
//                            guard let name = business[ParameterValues.Name] as? String else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'name'")
//                                return
//                            }
//
//                            guard let rating = business[ParameterValues.Rating] as? Double else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'rating")
//                                return
//                            }
//
//                            guard let price = business[ParameterValues.Price] as? String else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'price'")
//                                return
//                            }
//
//                            guard let isClosed = business[ParameterValues.IsClosed] as? Int else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'isClosed'")
//                                return
//                            }
//
//                            guard let distance = business[ParameterValues.Distance] as? Double else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'distance'")
//                                return
//                            }
//
//                            guard let coordinates = business[ParameterKeys.Coordinates] as? [String:Any] else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'coordinates'")
//                                return
//                            }
//
//                            guard let latitude = coordinates[ParameterValues.Latitude] as? Double else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'latitude'")
//                                return
//                            }
//
//                            guard let longitude = coordinates[ParameterValues.Longitude] as? Double else {
//                                completionHandlerForSearchResults(false, "Unable to find key 'longitude'")
//                                return
//                            }
                            
//                            Location.shared.name = name
//                            Location.shared.rating = rating
//                            Location.shared.price = price
//                            Location.shared.isClosed = isClosed
//                            Location.shared.distance = distance
//                            Location.shared.latitude = latitude
//                            Location.shared.longitude = longitude
//                            print(name)
//                            print(rating)
//                            print(price)
    }

}
