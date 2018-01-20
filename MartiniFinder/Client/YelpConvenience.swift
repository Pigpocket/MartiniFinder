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
    
    func getYelpSearchResults(_ term: String, _ price: String, _ latitude: Double, _ longitude: Double, completionHandlerForSearchResults: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
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
                completionHandlerForSearchResults(false, "There was an error getting the images: \(error)")
            } else {
                
                if let results = results {
                    
                    if let businesses = results["businesses"] as? [[String:AnyObject]] {

                        for business in businesses {
                            
                            guard let name = business[ParameterValues.Name] as? String else {
                                completionHandlerForSearchResults(false, "Unable to find key 'name' in \(ParameterValues.Name) in \(business)")
                                return
                            }
                            
                            guard let rating = business[ParameterValues.Rating] as? Double else {
                                completionHandlerForSearchResults(false, "Unable to find key 'name' in \(ParameterValues.Rating) in \(business)")
                                return
                            }
                            
                            guard let price = business[ParameterValues.Price] as? String else {
                                completionHandlerForSearchResults(false, "Unable to find key 'price' in \(ParameterValues.Price) in \(business)")
                                return
                            }
                            
                            guard let isClosed = business[ParameterValues.IsClosed] as? Int else {
                                completionHandlerForSearchResults(false, "Unable to find key 'isClosed' in \(ParameterValues.Price) in \(business)")
                                return
                            }
                            
                            guard let distance = business[ParameterValues.Distance] as? Double else {
                                completionHandlerForSearchResults(false, "Unable to find key 'distance' in \(ParameterValues.Distance) in \(business)")
                                return
                            }
                            
                            print(name)
                            print(rating)
                            print(price)
                            print(isClosed)
                            print(distance)
                            print("********")
                        }
                    }
                
                }
            }
        }
    }

}
