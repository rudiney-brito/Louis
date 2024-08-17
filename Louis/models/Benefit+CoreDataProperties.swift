//
//  Benefit+CoreDataProperties.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData


extension Benefit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Benefit> {
        return NSFetchRequest<Benefit>(entityName: "Benefit")
    }

    @NSManaged public var name: String?

}

extension Benefit : Identifiable {

}
