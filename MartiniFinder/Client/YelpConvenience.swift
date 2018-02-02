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
    }

}
