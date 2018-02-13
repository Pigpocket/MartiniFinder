//
//  Favorite+CoreDataClass.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/12/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Favorite)
public class Favorite: NSManagedObject {

    convenience init(id: String, name: String, rating: Double, price: String, latitude: Double, longitude: Double, imageUrl: String, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: entity, insertInto: context)
            self.id = id
            self.name = name
            self.rating = rating
            self.price = price
            self.latitude = latitude
            self.longitude = longitude
            self.imageUrl = imageUrl
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
