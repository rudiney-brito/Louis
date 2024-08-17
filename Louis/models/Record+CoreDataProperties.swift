//
//  Record+CoreDataProperties.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }
    @NSManaged public var headerLogoData: Data?
    @NSManaged public var headerLogo: String?
    @NSManaged public var subscription: Subscription?

}

extension Record : Identifiable {

}
