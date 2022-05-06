//
//  SettingsController.swift
//  Cards
//
//  Created by Dreik on 5/6/22.
//

import UIKit

class SettingsController: UITableViewController {
    let pairsCardsKey = "Pairs cards count"
    @IBOutlet var pairsCardsStepper: UIStepper!
    @IBOutlet var pairsCountLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        setPairsCardsCount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pairsCardsCountChanged(_ sender: UIStepper) {
        UserDefaults.standard.set(pairsCardsStepper.value, forKey: pairsCardsKey)
        pairsCountLabel.text = String(Int(pairsCardsStepper.value))
        print(pairsCardsStepper.value)
    }
    
    private func setPairsCardsCount() {
        if UserDefaults.standard.object(forKey: pairsCardsKey) == nil {
            UserDefaults.standard.set(pairsCardsStepper.value, forKey: pairsCardsKey)
        } else {
            pairsCardsStepper.value = UserDefaults.standard.object(forKey: pairsCardsKey) as! Double
        }
        pairsCountLabel.text = String(Int(pairsCardsStepper.value))
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
