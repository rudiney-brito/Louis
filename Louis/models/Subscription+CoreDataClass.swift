//
//  Subscription+CoreDataClass.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData

@objc(Subscription)
public class Subscription: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case coverImage
        case disclaimer
        case offerPageStyle
        case subscribeSubtitle
        case subscribeTitle
        case benefits
        case offers
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagerObjectContext
        }
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coverImage = try container.decode(String.self, forKey: .coverImage)
        self.disclaimer = try  container.decode(String.self, forKey: .disclaimer)
        self.offerPageStyle = try container.decode(String.self, forKey: .offerPageStyle)
        self.subscribeSubtitle = try container.decode(String.self, forKey: .subscribeSubtitle)
        self.subscribeTitle = try container.decode(String.self, forKey: .subscribeTitle)
        
        let benefits = try container.decode([String].self, forKey: .benefits)
        
        benefits.forEach({ benefit in
            let newBenefit = Benefit(context: context)
            newBenefit.name = benefit
            self.benefits?.insert(newBenefit)
        })
        
        let offers = try container.decode([String: OfferItem].self, forKey: .offers)
        
        for offer in offers {
            let newOffer = Offer(context: context)
            newOffer.id = offer.key
            newOffer.name = offer.value.description
            newOffer.price = offer.value.price
            self.offers?.insert(newOffer)
        }
    }
}


struct OfferItem: Decodable {
    let price: Double
    let description: String
}
