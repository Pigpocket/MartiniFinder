//
//  YelpClient.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/5/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import Foundation

class YelpClient {
    
    let request = String("GET https://api.yelp.com/v3/businesses/search")
    
    func taskForGetYelpSearchResults(method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = URL(string: YelpClient.Constants.YelpBaseURL + method)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: ParseClient.JSONParameterKeys.RestAPIKey)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 0, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 3, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForGetStudentLocationParse(nil, NSError(domain: "taskForGetStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            /* Parse the data */
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForGetStudentLocationParse)
            
        }
        task.resume()
    }
}
