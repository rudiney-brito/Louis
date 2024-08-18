//
//  Offer+CoreDataProperties.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData


extension Offer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offer> {
        return NSFetchRequest<Offer>(entityName: "Offer")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double

}

