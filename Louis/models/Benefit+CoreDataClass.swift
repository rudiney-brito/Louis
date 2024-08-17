//
//  Benefit+CoreDataClass.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData

@objc(Benefit)
public class Benefit: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagerObjectContext
        }
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }

}
