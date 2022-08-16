//
//  BoardGamePresenter.swift
//  Cards
//
//  Created by Dreik on 8/14/22.
//

import UIKit
import CoreData

class BoardGamePresenter {
    weak private var boardGameViewDelegate: BoardGameViewDelegate?
    
    func getSettingsFromUserDefaults() {
        
    }
    
    func newGameStarted() {
        getSettingsFromUserDefaults()
    }
    
    func loadOrCreateLastGame() {
        
    }
}
