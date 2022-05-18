//
//  BoardGameController.swift
//  Cards
//
//  Created by Dreik on 5/5/22.
//

import UIKit

class BoardGameController: UIViewController {
    
    // счетчик переворотов карт
    @IBOutlet weak var flipCounterLabel: UILabel!
    lazy var flipCounterStack = setFlipCounterView()
    // кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
    // кнопка для переворота всех карточек
    lazy var flipButtonView = getflipAllCardsButtonView()
    // количество пар уникальных карточек
    lazy var cardsPairsCounts = setPairsCardsCount()
    // сущность "Игра"
    lazy var game: Game = startNewGame()
    // игровое поле
    lazy var boardGameView = getBoardGameView()
    // размеры карточек
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    // предельные координаты размещения карточки
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    var cardViews = [UIView]()
    private var flippedCards = [UIView]()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(flipCounterStack)
        // добавляем кнопку на сцену
        view.addSubview(startButtonView)
        // добавляем кнопку переворота на сцену
        view.addSubview(flipButtonView)
        // добавляем игровое поле на сцену
        view.addSubview(boardGameView)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setFlipCounterView() -> UIStackView {
        let flipCounterStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 80, height: 21))
        
        flipCounterStackView.axis = .horizontal
        flipCounterStackView.alignment = .firstBaseline // .fill .leading .firstBaseline .center .trailing .lastBaseline
        flipCounterStackView.distribution = .fill // . fill .fillEqually .fillProportionally .equalSpacing .equalCentering
        flipCounterStackView.spacing = 10

        let label = UILabel()
        let counterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        label.text = "Flips:"
        counterLabel.text = "0"
        counterLabel.textAlignment = .left
        flipCounterStackView.addArrangedSubview(label)
        flipCounterStackView.addArrangedSubview(counterLabel)
        
        flipCounterStackView.center.x = view.center.x - 125
        flipCounterStackView.center.y = 120
        
        flipCounterLabel = counterLabel
        
        return flipCounterStackView
    }
    
    private func getStartButtonView() -> UIButton {
        // 1. Создаем кнопку
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        // 2. Изменяем положение кнопки
        button.center.x = view.center.x
        
        // получаем доступ к текущему окну
        let window = UIApplication.shared.windows[0]
        // определяем отступ сверху от границ окна до Safe Area
        let topPadding = window.safeAreaInsets.top + 50
        // устанавливаем координату Y кнопки в соответствии с отступом
        button.frame.origin.y = topPadding
        
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
        
        // подключаем обработчик нажатия на кнопку
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        
        return button
    }

    
    private func setPairsCardsCount() -> Int {
        if UserDefaults.standard.object(forKey: "Pairs cards count") == nil {
            let startPairsCardsCount = 4
            
            UserDefaults.standard.set(startPairsCardsCount, forKey: "Pairs cards count")
            
            return startPairsCardsCount
        }
        
        return Int(UserDefaults.standard.object(forKey: "Pairs cards count") as! Double)
    }
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        // удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        flippedCards = []
        cardViews = cards
        // перебираем карточки
        for card in cardViews {
            // для каждой карточки генерируем случайные координаты
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            // размещаем карточку на игровом поле
            boardGameView.addSubview(card)
        }
    }
    
    // генерация массива карточек на основе данных Модели
    private func getCardsBy(modelData: [Card]) -> [UIView] {
        // хранилище для представлений карточек
        var cardViews = [UIView]()
        // фабрика карточек
        let cardViewFactory = CardViewFactory()
        // перебираем массив карточек в Модели
        for (index, modelCard) in modelData.enumerated() {
            // добавляем первый экземпляр карты
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            // добавляем второй экземпляр карты
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        // добавляем всем картам обработчик переворота
        for card in cardViews {
            
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                // переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                // добавляем или удаляем карточку
                if flippedCard.isFlipped {
                    changeFlipCounterValue()
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                // если перевернуто 2 карточки
                if self.flippedCards.count == 2 {
                    compareTwoCards()
                }
            }
        }
        
        return cardViews
    }
    
    private func changeFlipCounterValue() {
        let currentFlipCount = Int(flipCounterLabel.text ?? "0") ?? 0
        
        flipCounterLabel.text = String(currentFlipCount + 1)
    }

    private func compareTwoCards() {
        // получаем карточки из данных модели
        let firstCard = game.cards[self.flippedCards.first!.tag]
        let secondCard = game.cards[self.flippedCards.last!.tag]
        
        // если карточки одинаковые
        if game.checkCards(firstCard, secondCard) {
            // сперва анимировано скрываем их
            UIView.animate(withDuration: 0.3, animations: {
                self.flippedCards.first!.layer.opacity = 0
                self.flippedCards.last!.layer.opacity = 0
                // после чего удаляем из иерархии
            }, completion: { _ in
                self.flippedCards.first!.removeFromSuperview()  // иногда здесь вылетает ошибка
                self.flippedCards.last!.removeFromSuperview()
                self.flippedCards = []
            })
            // в ином случае
        } else {
            // переворачиваем карточки рубашкой вверх
            for card in self.flippedCards {
                (card as! FlippableView).flip()
            }
        }
    }
    
    private func getBoardGameView() -> UIView {
        // отступ игрового поля от ближайших элементов
        let margin: CGFloat = 10
        let boardView = UIView()
        
        // указываем координаты
        // x
        boardView.frame.origin.x = margin
        // y
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top + 50
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        
        // рассчитаем ширину
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        // рассчитываем высоту
        // с учетом нижнего отступа
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        // изменяем стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
        
    private func getflipAllCardsButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        button.center.x = view.center.x + 120
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top + 50
        button.frame.origin.y = topPadding
        
        button.setTitle("Flip all cards", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 10
        
        // более новая версия обработчика, аналог .addTarget
        button.addAction(UIAction(title: "", handler: { action in
            self.flipAllCards(button)
        }), for: .touchUpInside)
        
        return button
    }
    
    func flipAllCards(_ sender: UIButton) {
        if flippedCards.isEmpty || flippedCards.count == 1 {
            for card in cardViews {
                (card as! FlippableView).isFlipped = true
                flippedCards.append(card)
            }
        } else if !flippedCards.isEmpty {
            for card in cardViews {
                (card as! FlippableView).isFlipped = false
                flippedCards = []
            }
        }
    }

    @objc func startGame(_ sender: UIButton) {
        game = startNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
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
