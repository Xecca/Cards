//
//  SettingsController.swift
//  Cards
//
//  Created by Dreik on 5/6/22.
//

import UIKit

class SettingsController: UITableViewController {
    private var cardColors: [String: Bool] = UserDefaults.standard.object(forKey: SettingsKeys.figuresColorsKey.rawValue) as? [String: Bool] ?? cardColor
    
    @IBOutlet var pairsCardsStepper: UIStepper!
    @IBOutlet var pairsCountLabel: UILabel!
    @IBOutlet weak var backsideShapes: UISegmentedControl!
    // формы фигур
    @IBOutlet var figureTypeButtons: [UIButton]!
    // цвета фигур
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
        // сохранить все выбранные настройки
        saveSettings()
    }
    
    private func updateSettingsValues() {
        pairsCardsStepper.value = UserDefaults.standard.object(forKey: SettingsKeys.pairsCardsCountKey.rawValue) as! Double
        pairsCountLabel.text = String(Int(UserDefaults.standard.object(forKey: SettingsKeys.pairsCardsCountKey.rawValue) as! Double))
        backsideShapes.selectedSegmentIndex = UserDefaults.standard.object(forKey: SettingsKeys.backSideFiguresKey.rawValue) as! Int
        // устанавливаем стартовые изображения для типов карт
        setTypesImagesToButtons()
        // устанавливаем стартовые цвета на кнопки
        setColorsToButtons()
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(pairsCardsStepper.value, forKey: SettingsKeys.pairsCardsCountKey.rawValue)
        UserDefaults.standard.set(backsideShapes.selectedSegmentIndex, forKey: SettingsKeys.backSideFiguresKey.rawValue)
        // сохраняем выбранные типы
        // ...
        // сохраняем выбранные цвета
        // ...
    }
    
    private func setTypesImagesToButtons() {
        for i in 0..<figureTypeImageNameOn.count {
            figureTypeButtons[i].setImage(UIImage(named: figureTypeImageNameOn[i]!), for: .normal)
            figureTypeButtons[i]
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
    
    // MARK: - Table view data source
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}