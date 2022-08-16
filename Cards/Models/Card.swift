//
//  Card.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import Foundation
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
// координаты карточки
var coordinateX = 0
var coordinateY = 0

// игральная карточка
typealias Card = (type: CardType, color: CardColor, coordinateX: Int, coordinateY: Int, isFlipped: Bool, tag: Int)

func getFigureTypeStringFrom(type: CardType) -> String {
    switch type {
    case .fill:
        return "fill"
    case .noFillCircle:
        return "noFillCircle"
    case .circle:
        return "circle"
    case .cross:
        return "cross"
    case .square:
        return "square"
    }
}

func getFigureColorStringFrom(color: CardColor) -> String {
    switch color {
    case .red:
        return "red"
    case .black:
        return "black"
    case .brown:
        return "brown"
    case .gray:
        return "gray"
    case .green:
        return "green"
    case .orange:
        return "orange"
    case .purple:
        return "purple"
    case .yellow:
        return "yellow"
    }
}

func getFrontFigureType(typeName: String) -> CardType {
    switch typeName {
    case "fill":
        return .fill
    case "noFillCircle":
        return .noFillCircle
    case "circle":
        return .circle
    case "cross":
        return .cross
    case "square":
        return .square
    default:
        return .circle
    }
}

func getFrontFigureColor(colorName: String) -> CardColor {
    switch colorName {
    case "red":
        return .red
    case "black":
        return .black
    case "brown":
        return .brown
    case "gray":
        return .gray
    case "green":
        return .green
    case "orange":
        return .orange
    case "purple":
        return .purple
    case "yellow":
        return .yellow
    default:
        return .red
    }
}
