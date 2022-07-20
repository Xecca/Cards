//
//  CardData+CoreDataProperties.swift
//  Cards
//
//  Created by Dreik on 7/20/22.
//
//

import Foundation
import CoreData


extension CardData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardData> {
        return NSFetchRequest<CardData>(entityName: "CardData")
    }

    @NSManaged public var backSideFigure: String?
    @NSManaged public var frontSideFigure: String?
    @NSManaged public var coordinateX: Int32
    @NSManaged public var coordinateY: Int32
    @NSManaged public var frontFigureColor: String?
    @NSManaged public var isFlipped: Bool
    @NSManaged public var game: GameData?

}

extension CardData : Identifiable {

}
