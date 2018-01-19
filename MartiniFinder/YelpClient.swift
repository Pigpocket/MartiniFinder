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
    
    //let request = String("GET https://api.yelp.com/v3/businesses/search")
    
    func taskForGetYelpSearchResults(method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        let session = URLSession.shared
        let url = URL(string: YelpClient.Constants.YelpBaseURL + method)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(YelpClient.Constants.Authorization, forHTTPHeaderField: YelpClient.Constants.APIKey)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* GUARD: There is no error */
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(String(describing: error))"]
                completionHandlerForGET(nil, NSError(domain: "taskForGetYelpSearchResults", code: 0, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetYelpSearchResults", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetYelpSearchResults", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetYelpSearchResults", code: 3, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForGET(nil, NSError(domain: "taskForGetStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            /* Parse the data */
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        task.resume()
    }
    
    func parseJSONObject(_ data: Data, completionHandlerForConvertData: (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "parseJSONObject", code: 0, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    class func sharedInstance() -> YelpClient {
        struct Singleton {
            static var sharedInstance = YelpClient()
        }
        return Singleton.sharedInstance
    }
}
