//
//  Favorite+CoreDataProperties.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 1/25/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool

}
