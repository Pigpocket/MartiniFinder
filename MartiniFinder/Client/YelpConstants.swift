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
        static let YelpWebURL = "https://www.yelp.com/"
        static let APIKey = "Bearer 8UOe63-UqKM8syYDjMXsdbJbMXWg1Hp6Tu0_kgQr_wUMP3Y2NEDXZE_Tdc_C_xSjihkl2PeM3n9sveqQ1bdXm2AQ1bviVEo1qpUbAk9m_3CmQv3wSlnYZ8qp5j5RWnYx"
    }
    
    struct Methods {
        static let Businesses = "businesses/"
        static let Biz = "biz/"
        static let Search = "search"
        static let Id = "id"
    }
    
    struct ParameterKeys {
        static let Term = "term"
        static let Coordinates = "coordinates"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Radius = "radius"
        static let OpenAt = "open_at"
        static let Price = "price"
    }
    
    struct ParameterValues {
        
        static let Id = "id"
        static let Name = "name"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Rating = "rating"
        static let Price = "price"
        static let Distance = "distance"
        static let isOpenNow = "is_open_now"
        static let ImageUrl = "image_url"
    }
    
}
