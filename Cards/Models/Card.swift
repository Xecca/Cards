//
//  Card.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import Foundation
import UIKit

protocol CardProtocol {
//    var frontSideView: UIView { get set }
//    var backSideView: UIView { get set }
    var coordinateX: Int32 { get }
    var coordinateY: Int32 { get }
    var frontFigureType: String { get set }
    var frontFigureColor: String { get set }
//    var isFlipped: Bool { get }
    
    func getUIColor(colorName: String) -> UIColor
    func getFigureTypeString(type: Card) -> String
    func getFigureColorString(color: Card) -> String
//    func getBackFigureType(typeName: String) -> FigureType
    func getFrontFigureType(typeName: String) -> CardType
    func getFrontFigureColor(colorName: String) -> CardColor
}

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

func getFigureTypeStringFrom(type: Card) -> String {
    switch type.type {
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

func getFigureColorStringFrom(color: Card) -> String {
    switch color.color {
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
