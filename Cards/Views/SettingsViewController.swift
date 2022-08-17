//
//  SettingsController.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import UIKit

class SettingsViewController: UITableViewController {
    private var cardColors: [String: Bool] = UserDefaults.standard.object(forKey: SettingsKeys.figuresColorsKey.rawValue) as? [String: Bool] ?? cardColor
    
    @IBOutlet var pairsCardsStepper: UIStepper!
    @IBOutlet var pairsCountLabel: UILabel!
    @IBOutlet weak var backsideShapes: UISegmentedControl!
    // figure's shapes
    @IBOutlet var figureTypeButtons: [UIButton]!
    // figure's colors
    @IBOutlet var cardColorsButtons: [UIButton]!
    
    override func loadView() {
        super.loadView()
        
        updateSettingsValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveSettings()
    }
    
    private func updateSettingsValues() {
        pairsCardsStepper.value = UserDefaults.standard.object(forKey: SettingsKeys.pairsCardsCountKey.rawValue) as! Double
        pairsCountLabel.text = String(Int(UserDefaults.standard.object(forKey: SettingsKeys.pairsCardsCountKey.rawValue) as! Double))
//        backsideShapes.selectedSegmentIndex = UserDefaults.standard.object(forKey: SettingsKeys.backSideFiguresKey.rawValue) as! Int
        
        setTypesImagesToButtons()
        setColorsToButtons()
    }
    
    private func saveSettings() {
        // save amount of card's pairs
        UserDefaults.standard.set(pairsCardsStepper.value, forKey: SettingsKeys.pairsCardsCountKey.rawValue)
        // save selected back side figure's types
        UserDefaults.standard.set(backsideShapes.selectedSegmentIndex, forKey: SettingsKeys.backSideFiguresKey.rawValue)
        // save chosen front figure's types
        // ...
        // save chosen front figure's colors
        // ...
    }
    
    private func setTypesImagesToButtons() {
        for i in 0..<figureTypeImageNameOn.count {
            figureTypeButtons[i].setImage(UIImage(named: figureTypeImageNameOn[i]!), for: .normal)
        }
    }
    
    private func setColorsToButtons() {
        for i in 0...7 {
            cardColorsButtons[i].backgroundColor = getUIColorFromIndex(i)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func pairsCardsCountChanged(_ sender: UIStepper) {
        pairsCountLabel.text = String(Int(pairsCardsStepper.value))
    }
    
    @IBAction func pressedTypeButton(_ sender: UIButton) {
        //        UserDefaults.standard.set(CardType.self, forKey: SettingsKeys.figuresTypesKey.rawValue)
        let tag = sender.tag
        
        figureTypeButtons[tag].currentImage == UIImage(named: figureTypeImageNameOn[tag]!) ? figureTypeButtons[tag].setImage(UIImage(named: figureTypeImageNameOff[tag]!), for: .normal) : figureTypeButtons[tag].setImage(UIImage(named: figureTypeImageNameOn[tag]!), for: .normal)
    }
    
    @IBAction func pressedColorButton(_ sender: UIButton) {
        let tag = sender.tag
        
        if cardColors[cardUIColor[tag]!] == false {
            cardColorsButtons[tag].backgroundColor = getUIColorFromIndex(tag)
        } else {
            cardColorsButtons[tag].backgroundColor = UIColor.systemGray5
            cardColorsButtons[tag].tintColor = getUIColorFromIndex(tag)
            cardColorsButtons[tag].setTitle(cardUIColor[tag]!, for: .normal)
        }
        cardColors[cardUIColor[tag]!]?.toggle()
    }
}
