//
//  Card.swift
//  Cards
//
//  Created by Dreik on 5/5/22.
//

import UIKit

// тип фигуры карт
enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
    case noFillCircle
}

// цвета карт
enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}

// игральная карточка
typealias Card = (type: CardType, color: CardColor)

