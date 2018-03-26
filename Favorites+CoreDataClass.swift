//
//  Favorites+CoreDataClass.swift
//  
//
//  Created by Tomas Sidenfaden on 3/25/18.
//
//

import Foundation
import CoreData


public class Favorites: NSManagedObject {

    convenience init(id: String, name: String, price: String, rating: Double, isFavorite: Bool, imageUrl: String, latitude: Double, longitude: Double, image: NSData, reviewCount: Int16, context: NSManagedObjectContext) {
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
            self.reviewCount = reviewCount
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
