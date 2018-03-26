//
//  Favorites+CoreDataProperties.swift
//  
//
//  Created by Tomas Sidenfaden on 3/25/18.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: NSData?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int16

}
