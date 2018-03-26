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
        static let authorization = "Authorization"
        static let yelpBaseURL = "https://api.yelp.com/v3/"
        static let yelpWebURL = "https://www.yelp.com/"
        static let apiKey = "Bearer 8UOe63-UqKM8syYDjMXsdbJbMXWg1Hp6Tu0_kgQr_wUMP3Y2NEDXZE_Tdc_C_xSjihkl2PeM3n9sveqQ1bdXm2AQ1bviVEo1qpUbAk9m_3CmQv3wSlnYZ8qp5j5RWnYx"
    }
    
    struct Methods {
        static let businesses = "businesses/"
        static let biz = "biz/"
        static let search = "search"
        static let id = "id"
    }
    
    struct ParameterKeys {
        static let term = "term"
        static let coordinates = "coordinates"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let radius = "radius"
        static let price = "price"
    }
    
    struct ParameterValues {
        
        static let id = "id"
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let rating = "rating"
        static let price = "price"
        static let distance = "distance"
        static let isOpenNow = "is_open_now"
        static let imageUrl = "image_url"
        static let reviewCount = "review_count"
    }
    
}
