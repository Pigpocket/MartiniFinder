//
//  YelpConstants.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/6/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import Foundation

extension YelpClient {
    
    struct Constants {
        static let Authorization = "Authorization"
        static let YelpBaseURL = "https://api.yelp.com/v3/"
        static let APIKey = "Bearer 8UOe63-UqKM8syYDjMXsdbJbMXWg1Hp6Tu0_kgQr_wUMP3Y2NEDXZE_Tdc_C_xSjihkl2PeM3n9sveqQ1bdXm2AQ1bviVEo1qpUbAk9m_3CmQv3wSlnYZ8qp5j5RWnYx"
    }
    
    struct Methods {
        static let Businesses = "businesses/"
        static let Search = "search"
    }
    
    struct ParameterKeys {
        static let Term = "term"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Radius = "radius"
        static let OpenNow = "open_now"
        static let Price = "price"
    }
    
    struct ParameterValues {
        static let Name = "name"
        static let Rating = "rating"
        static let Price = "price"
        static let Distance = "distance"
        static let IsClosed = "is_closed"
    }
    
}
