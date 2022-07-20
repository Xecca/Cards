//
//  GameData+CoreDataProperties.swift
//  Cards
//
//  Created by Dreik on 7/20/22.
//
//

import Foundation
import CoreData


extension GameData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameData> {
        return NSFetchRequest<GameData>(entityName: "GameData")
    }

    @NSManaged public var flipsCount: Int32
    @NSManaged public var name: String?
    @NSManaged public var time: Int32
    @NSManaged public var cards: NSOrderedSet?

}

// MARK: Generated accessors for cards
extension GameData {

    @objc(insertObject:inCardsAtIndex:)
    @NSManaged public func insertIntoCards(_ value: CardData, at idx: Int)

    @objc(removeObjectFromCardsAtIndex:)
    @NSManaged public func removeFromCards(at idx: Int)

    @objc(insertCards:atIndexes:)
    @NSManaged public func insertIntoCards(_ values: [CardData], at indexes: NSIndexSet)

    @objc(removeCardsAtIndexes:)
    @NSManaged public func removeFromCards(at indexes: NSIndexSet)

    @objc(replaceObjectInCardsAtIndex:withObject:)
    @NSManaged public func replaceCards(at idx: Int, with value: CardData)

    @objc(replaceCardsAtIndexes:withCards:)
    @NSManaged public func replaceCards(at indexes: NSIndexSet, with values: [CardData])

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CardData)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CardData)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSOrderedSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSOrderedSet)

}

extension GameData : Identifiable {

}
