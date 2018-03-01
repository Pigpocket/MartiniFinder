//
//  Favorites+CoreDataClass.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/28/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
//

import Foundation
import CoreData


public class Favorites: NSManagedObject {

    convenience init(id: String, name: String, price: String, rating: Double, isFavorite: Bool, imageUrl: String, latitude: Double, longitude: Double, image: NSData, isOpenNow: Bool, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context) {
            self.init(entity: entity, insertInto: context)
            self.id = id
            self.name = name
            self.price = price
            self.rating = rating
            self.imageUrl = imageUrl
            self.latitude = latitude
            self.longitude = longitude
            self.isFavorite = isFavorite
            self.image = image
            self.isOpenNow = isOpenNow
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
