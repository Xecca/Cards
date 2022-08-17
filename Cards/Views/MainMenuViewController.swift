//
//  ViewController.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

// TODO: -
// 1. Отделить бизнес-логику от UI-слоя
// 2. Вынести работу с кордатой в отдельный сервис
// 3. Применить архитектуру MVP
// 4. TDD
// 5. Убрать лишние комменты
// 

import UIKit

final class Presenter
{
    private var vc: MainMenuViewController?
    
    func continueButtonPressed(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "continue button doesn't work")
        
        let lastGameViewController = self.vc?.storyboard?.instantiateViewController(withIdentifier: "BoardViewController") as! BoardGameViewController
        lastGameViewController.isContinue = true
        self.vc?.show(lastGameViewController, sender: true)
    }
    
    func didLoad(vc: MainMenuViewController) {
        self.vc = vc
    }
}

final class MainMenuViewController: UIViewController {
    private let presenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.didLoad(vc: self)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        self.presenter.continueButtonPressed(sender)
    }
}

