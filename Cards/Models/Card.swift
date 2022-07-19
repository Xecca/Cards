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
//    var margin: Int { get }
    var coordinateX: Int32 { get set }
    var coordinateY: Int32 { get set }
//    var cornerRadius: Int32 { get set }
    var frontFigureType: String { get set }
    var frontFigureColor: String { get set }
//    var backFigureType: String { get set }
//    var backFigureColor: String { get set }
    
    func getUIColor(colorName: String) -> UIColor
//    func getBackFigureType(typeName: String) -> FigureType
//    func getFrontFigureType(typeName: String) -> FigureType
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