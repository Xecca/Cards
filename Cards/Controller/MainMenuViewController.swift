//
//  MainMenuViewController.swift
//  Cards
//
//  Created by Dreik on 5/6/22.
//

import UIKit

class MainMenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateSettings()
    }
    
    private func updateSettings() {
        if UserDefaults.standard.object(forKey: SettingsKeys.pairsCardsCountKey.rawValue) == nil {
            UserDefaults.standard.set(8, forKey: SettingsKeys.pairsCardsCountKey.rawValue)
        }
        if UserDefaults.standard.object(forKey: SettingsKeys.backSideFiguresKey.rawValue) == nil {
            UserDefaults.standard.set(2, forKey: SettingsKeys.backSideFiguresKey.rawValue)
        }
        
//        if UserDefaults.standard.object(forKey: SettingsKeys.figuresTypesKey.rawValue) == nil {
//            UserDefaults.standard.set(CardType.allCases, forKey: SettingsKeys.figuresTypesKey.rawValue)
//        }
        if UserDefaults.standard.object(forKey: SettingsKeys.figuresColorsKey.rawValue) == nil {
            UserDefaults.standard.set(cardColor, forKey: SettingsKeys.figuresColorsKey.rawValue)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
