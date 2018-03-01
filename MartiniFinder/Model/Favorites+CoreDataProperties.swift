//
//  Favorites+CoreDataProperties.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/28/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var rating: Double
    @NSManaged public var image: NSData?
    @NSManaged public var isOpenNow: Bool

}
