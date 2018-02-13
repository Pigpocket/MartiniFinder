//
//  Favorite+CoreDataClass.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/25/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Favorite)
public class Favorite: NSManagedObject {

    convenience init(name: String, isFavorite: Bool, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Location", in: context) {
            self.init(entity: entity, insertInto: context)
            self.name = name
            self.isFavorite = isFavorite
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
