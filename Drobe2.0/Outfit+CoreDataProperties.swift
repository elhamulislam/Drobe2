//
//  Outfit+CoreDataProperties.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-12.
//
//

import Foundation
import CoreData


extension Outfit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Outfit> {
        return NSFetchRequest<Outfit>(entityName: "Outfit")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var clothingItems: NSSet?
    
    var clothingSet: Set<ClothingItem> {
            clothingItems as? Set<ClothingItem> ?? []
        }

}

// MARK: Generated accessors for clothingItems
extension Outfit {

    @objc(addClothingItemsObject:)
    @NSManaged public func addToClothingItems(_ value: ClothingItem)

    @objc(removeClothingItemsObject:)
    @NSManaged public func removeFromClothingItems(_ value: ClothingItem)

    @objc(addClothingItems:)
    @NSManaged public func addToClothingItems(_ values: NSSet)

    @objc(removeClothingItems:)
    @NSManaged public func removeFromClothingItems(_ values: NSSet)

}
