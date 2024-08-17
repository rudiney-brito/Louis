//
//  Subscription+CoreDataProperties.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension Subscription {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subscription> {
        return NSFetchRequest<Subscription>(entityName: "Subscription")
    }

    @NSManaged public var coverImageData: Data?
    @NSManaged public var coverImage: String?
    @NSManaged public var disclaimer: String?
    @NSManaged public var offerPageStyle: String?
    @NSManaged public var subscribeSubtitle: String?
    @NSManaged public var subscribeTitle: String?
    @NSManaged public var benefits: Set<Benefit>?
    @NSManaged public var offers: Set<Offer>?

}

// MARK: Generated accessors for benefits
extension Subscription {

    @objc(addBenefitsObject:)
    @NSManaged public func addToBenefits(_ value: Benefit)

    @objc(removeBenefitsObject:)
    @NSManaged public func removeFromBenefits(_ value: Benefit)

    @objc(addBenefits:)
    @NSManaged public func addToBenefits(_ values: Set<Benefit>)

    @objc(removeBenefits:)
    @NSManaged public func removeFromBenefits(_ values: Set<Benefit>)

}

// MARK: Generated accessors for offers
extension Subscription {

    @objc(addOffersObject:)
    @NSManaged public func addToOffers(_ value: Offer)

    @objc(removeOffersObject:)
    @NSManaged public func removeFromOffers(_ value: Offer)

    @objc(addOffers:)
    @NSManaged public func addToOffers(_ values: Set<Offer>)

    @objc(removeOffers:)
    @NSManaged public func removeFromOffers(_ values: Set<Offer>)

}

extension Subscription : Identifiable {

}
