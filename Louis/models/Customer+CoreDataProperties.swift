//
//  Customer+CoreDataProperties.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var id: String?
    @NSManaged public var metadata: Metadata?
    @NSManaged public var record: Record?

}

extension Customer : Identifiable {

}
