//
//  Record+CoreDataClass.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData

@objc(Record)
public class Record: NSManagedObject, Decodable {

    enum CodingKeys: CodingKey {
        case headerLogo, subscription
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagerObjectContext
        }
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.headerLogo = try container.decode(String.self, forKey: .headerLogo)
        self.subscription = try container.decode(Subscription.self, forKey: .subscription)
    }
}
