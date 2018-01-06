//
//  YelpConstants.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/6/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation

extension YelpClient {
    
    struct Constants {
        let YelpBaseURL = "https://api.yelp.com/v3/"
    }
    
    struct Methods {
        let Businesses = "businesses/"
        let Search = "search/"
    }
    
    struct ParameterKeys {
        let Term = "term"
        let Latitude = "latitude"
        let Longitude = "longitude"
        let Radius = "radius"
        let OpenNow = "open_now"
        let Price = "price"
    }
    
}
