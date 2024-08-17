//
//  Customer+CoreDataClass.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagerObjectContext
}

@objc(Customer)
public class Customer: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
           case id, metadata, record
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagerObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.record = try container.decode(Record.self, forKey: .record)
        self.metadata = try container.decode(Metadata.self, forKey: .metadata)
    }
}
