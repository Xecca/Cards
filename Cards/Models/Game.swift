//
//  Game.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import UIKit
import CoreData

class Game {
    var cardsCount = 0
    var cards = [Card]()
    var flipsCount = 0
    
    // MARK: - Create a Card
    func createCard(type: CardType, color: CardColor) {
        let card: Card = (type: type, color: color, coordinateX: 0, coordinateY: 0, isFlipped: false, tag: 0)
        
        cards.append(card)
    }
    
    // MARK: - Generating random cards
    func generateRandomCards() {
        var cards = [Card]()
        
        for tag in 0..<cardsCount {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!, coordinateX: 0, coordinateY: 0, isFlipped: false, tag: tag)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    // MARK: - Restore cards from Core Data
    func generateCardsFromCoreData(_ lastGame: GameData?) {
        var cards = [Card]()
        
        if let gameData = lastGame, let cardsFromCoreData = gameData.cards?.mutableCopy() as? NSMutableOrderedSet {
            for card in cardsFromCoreData {
                
                guard let card = card as? CardData else {
                    return
                }
                
                let storedCard: Card = (type: getFrontFigureType(typeName: card.frontSideFigure ?? "square"), color: getFrontFigureColor(colorName: card.frontFigureColor ?? "yellow"), coordinateX: Int(card.coordinateX), coordinateY: Int(card.coordinateY), isFlipped: card.isFlipped, tag: Int(card.tag))
                cards.append(storedCard)
            }
        }
//        print("Succes! The card is added to storedCard!")
        
        self.cards = cards
    }
    
    func compareTwoCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        }
        return false
    }
}
