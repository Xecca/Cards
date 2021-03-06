//
//  Game.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import UIKit
import CoreData

class Game {
    // количество пар уникальных карточек
    var cardsCount = 0
    // массив сгенерированных карточек
    var cards = [Card]()
    // количество переворотов карт
    var flipsCount = 0
//    // количество перевернутых карточек
//    var flippedCardsCount = 0
    // Core Data cards
    var lastGame: GameData?
    var exampleCards: [Card] = [
        (type: CardType.circle, color: CardColor.red, coordinateX: 0, coordinateY: 5, isFlipped: false, tag: 0),
        (type: CardType.square, color: CardColor.green, coordinateX: 100, coordinateY: 100, isFlipped: true, tag: 1),
        (type: CardType.noFillCircle, color: CardColor.brown, coordinateX: 150, coordinateY: 34, isFlipped: false, tag: 2),
        (type: CardType.square, color: CardColor.green, coordinateX: 200, coordinateY: 139, isFlipped: false, tag: 1),
        (type: CardType.noFillCircle, color: CardColor.brown, coordinateX: 10, coordinateY: 134, isFlipped: false, tag: 2),
        (type: CardType.circle, color: CardColor.red, coordinateX: 139, coordinateY: 35, isFlipped: true, tag: 0)
    ]
    
    // MARK: - Create a Card
    // создание отдельной карты
    func createCard(type: CardType, color: CardColor) {
        let card: Card = (type: type, color: color, coordinateX: 0, coordinateY: 0, isFlipped: false, tag: 0)
        
        cards.append(card)
    }
    
    // MARK: - Generating random cards
    // генерация массива случайных карт
    func generateCards() {
        // генерируем новый массив карточек
        var cards = [Card]()
        
        for tag in 0..<cardsCount {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!, coordinateX: 0, coordinateY: 0, isFlipped: false, tag: tag)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    // MARK: - Restore cards from Core Data
    // восстановления массива сохраненных в CoreData карт
    func generateCardsFromCoreData(_ lastGame: GameData?) {
        // создаем новый массив для сохраненных карточек
        var cards = [Card]()
        
        print("currentGame cards' count: \(lastGame?.cards?.set.count ?? 0)")
        
        if let gameData = lastGame, let cardsFromCoreData = gameData.cards?.mutableCopy() as? NSMutableOrderedSet {
            for card in cardsFromCoreData {
                
                guard let card = card as? CardData else {
                    return
                }
                let storedCard: Card = (type: CardType.square, color: CardColor.red, coordinateX: Int(card.coordinateX), coordinateY: Int(card.coordinateY), isFlipped: card.isFlipped, tag: Int(card.tag))
                cards.append(storedCard)
                print("storedCard in generateCardsFromCoreData coordinateX: \(card.coordinateX)")
            }
        }
        print("Succes! The card is added to storedCard!")
        
        self.cards = cards
    }
    
    // проверка эквивалентности карточек
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        }
        return false
    }
}
