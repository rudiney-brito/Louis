//
//  Metadata+CoreDataClass.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData

@objc(Metadata)
public class Metadata: NSManagedObject, Decodable {

    enum CodingKeys: CodingKey {
           case createdAt, name, readCountRemaining, timeToExpire
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagerObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.name = try container.decode(String.self, forKey: .name)
        self.readCountRemaining = try container.decode(Int32.self, forKey: .readCountRemaining)
        self.timeToExpire = try container.decode(Int64.self, forKey: .timeToExpire)
    }
}
