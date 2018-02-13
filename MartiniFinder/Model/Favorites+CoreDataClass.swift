//
//  Favorites+CoreDataClass.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/12/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
//

import Foundation
import CoreData


public class Favorites: NSManagedObject {

    convenience init(id: String, name: String, price: String, rating: Double, isFavorite: Bool, latitude: Double, longitude: Double, imageUrl: String, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: entity, insertInto: context)
            self.id = id
            self.name = name
            self.price = price
            self.rating = rating
            self.isFavorite = isFavorite
            self.latitude = latitude
            self.longitude = longitude
            self.imageUrl = imageUrl
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
