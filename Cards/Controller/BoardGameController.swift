//
//  BoardGameController.swift
//  Cards
//
//  Created by Dreik on 5/5/22.
//

import UIKit

class BoardGameController: UIViewController {

    // кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
    // количество пар уникальных карточек
    var cardsPairsCounts = 8
    // сущность "Игра"
    lazy var game: Game = startNewGame()
    
    override func loadView() {
        super.loadView()
        
        // добавляем кнопку на сцену
        view.addSubview(startButtonView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func getStartButtonView() -> UIButton {
        // 1. Создаем кнопку
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        // 2. Изменяем положение кнопки
        button.center.x = view.center.x
        
        // 3. Настраиваем внешний вид кнопки
        // устанавливаем текст
        button.setTitle("Start game", for: .normal)
        // устанавливаем цвет текста для обычного (не нажатого) состояния
        button.setTitleColor(.black, for: .normal)
        // устанавливаем цвет текста для нажатого состояния
        button.setTitleColor(.gray, for: .highlighted)
        // устанавливаем фоновый цвет
        button.backgroundColor = .systemGray4
        // скругляем углы
        button.layer.cornerRadius = 10
        
        return button
    }
    
    private func startNewGame() -> Game {
        let game = Game()
        
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        
        return game
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
