//
//  CardViewFactory.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import UIKit

enum CardViewFactory {
    static func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        let frame = CGRect(origin: .zero, size: size)
        let viewColor = getViewColorBy(modelColor: color)
        
        switch shape {
        case .circle:
            return CardView<CircleShapeLayer>(frame: frame, color: viewColor)
        case .cross:
            return CardView<CrossShapeLayer>(frame: frame, color: viewColor)
        case .square:
            return CardView<SquareShapeLayer>(frame: frame, color: viewColor)
        case .fill:
            return CardView<FillShapeLayer>(frame: frame, color: viewColor)
        case .noFillCircle:
            return CardView<NoFillCircleShapeLayer>(frame: frame, color: viewColor)
        }
    }
    
    static func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .red:
            return .red
        case .green:
            return .green
        case .black:
            return .black
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
}
