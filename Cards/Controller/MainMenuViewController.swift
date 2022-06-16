//
//  MainMenuViewController.swift
//  Cards
//
//  Created by Dreik on 5/6/22.
//

import UIKit
import CoreData

class MainMenuViewController: UIViewController {
    
//    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard container != nil else {
//            fatalError("This view needs a persisten container.")
//        }
//
//        print("The persisten container is available.")
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
//        if let nextVC = segue.destination as? BoardGameController {
//            nextVC.container = container
//        }
    }
    

}
