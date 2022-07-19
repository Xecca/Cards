//
//  Settings.swift
//  Cards
//
//  Created by Dreik on 7/19/22.
//

import UIKit

enum SettingsKeys: String, CaseIterable {
    case pairsCardsCountKey = "Pairs cards count"
    case figuresTypesKey = "Figures types"
    case figuresColorsKey = "Figures colors"
    case backSideFiguresKey = "Backside figures"
    case flipsCount = "Flips count in last game"
    case cardsCoordinatesAndConditions = ""
    
}

let cardColor: [String: Bool] = [
    "red": true,
    "green": true,
    "black": true,
    "gray": true,
    "brown": true,
    "yellow": true,
    "purple": true,
    "orange": true
]

let cardUIColor: [Int: String] = [
    0: "red",
    1: "green",
    2: "black",
    3: "gray",
    4: "brown",
    5: "yellow",
    6: "purple",
    7: "orange"
    ]

let figureTypeImageNameOn: [Int: String] = [
    0: "circle",
    1: "cross",
    2: "square",
    3: "circle.nofilled",
    4: "vertical.rect"
]

let figureTypeImageNameOff: [Int: String] = [
    0: "no.circle",
    1: "no.cross",
    2: "no.square",
    3: "no.circle.nofilled",
    4: "no.vertical.rect"
]

func getUIColorFromIndex(_ index: Int) -> UIColor {
    switch index {
    case 0:
        return .red
    case 1:
        return .green
    case 2:
        return .black
    case 3:
        return .gray
    case 4:
        return .brown
    case 5:
        return .yellow
    case 6:
        return .purple
    case 7:
        return .orange
    default:
        return .white
    }
}

