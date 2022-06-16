//
//  Game.swift
//  Cards
//
//  Created by Dreik on 5/5/22.
//

import UIKit

class Game {
//    class Game: NSObject, NSSecureCoding {
//    func encode(with coder: NSCoder) {
//        coder.encode(cards, forKey: "Game")
//    }
//
//    required init?(coder: NSCoder) {
//        let mCards = coder.decodeObject(of: [NSArray.self, cards], forKey: "Card")
//    }
    
//    public static var supportsSecureCoding = true
    
    // количество пар уникальных карточек
    var cardsCount = 0
    // массив сгенерированных карточек
    var cards = [Card]()
    // количество переворотов карт
    var flipsCount = 0
    
    // генерация массива случайных карт
    func generateCards() {
        // генерируем новый массив карточек
        var cards = [Card]()
        
        for _ in 0..<cardsCount {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
            cards.append(randomElement)
        }
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
