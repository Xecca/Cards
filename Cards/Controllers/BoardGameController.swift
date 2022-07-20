//
//  BoardGameController.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import UIKit
import CoreData

class BoardGameController: UIViewController {

    @IBOutlet var flipCounterLabel: UILabel!
    @IBOutlet weak var startButtonView: UIButton!
    
    lazy var isContinue = false
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
    // количество пар уникальных карточек
    lazy var cardsPairsCount = setPairsCardsCount()
    var cardsInGame: Int = 0
    var isGameStarted: Bool = false
    var cardViews = [UIView]()
    private var flippedCards = [UIView]()
    // Core Data
    lazy var coreDataStack = CoreDataStack(modelName: "Cards")
    var currentGame: GameData?
    
    override func loadView() {
        super.loadView()
        
        // adds boardView
        view.addSubview(boardGameView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !game.exampleCards.isEmpty && isContinue == true {
            game = continueLastGame()
            print("Continue last game in viewDidLoad")
            
            // retrieve data about last game from Core Data
            loadOrCreateLastGame()
        }
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Сохраняем данные текущей игры в CoreData
        // 1. количество переворотов
        // 1.1. время, затраченное на игру
        // 2. Координаты каждой карты
        // 3. Цвета и тип фигуры лицевой стороны карты
        // 4.
        
        print("viewWillDisappear")
    }
    
    // MARK: - Side Menu Button action
    @objc func didTapMenuButton() {
        print("menu batton tapped")
//        self.didTapMenuButton()
    }
    
    // MARK: Start New Game
    @objc func startGame(_ sender: UIButton) {
        game = startNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        // check the last game in Core Data
//        setTheLastGame()
    }
    
    private func startNewGame() -> Game {
        print("Start New Game")
        let game = Game()
        
        game.cardsCount = cardsPairsCount
        game.generateCards()
        
        flipCounterLabel.text = "0"
        cardsInGame = game.cardsCount * 2
        isGameStarted = true
        
        return game
    }
    
    // MARK: - Continue Last Game
    private func continueLastGame() -> Game {
        print("Continue Last Game")
        let game = startNewGame()
        
        game.generateCardsFromCoreData()
    
        flipCounterLabel.text = "\(game.flipsCount)"
        cardsInGame = game.cards.count
        isGameStarted = true
        
        let cards = getCardsBy(storeData: game.cards)
        placeCardsOnBoardFromLastGame(cards)
        
        return game
    }
    
    // MARK: - Save Last Game Data
    private func saveLastGame() {
        
    }

    // MARK: - Board View
    private func getBoardGameView() -> UIView {
        // отступ игрового поля от ближайших элементов
        let margin: CGFloat = 10
        let boardView = UIView()
        
        // указываем координаты
        // x
        boardView.frame.origin.x = margin
        // y
        let topPadding = getSafeArea(.top) + startButtonView.frame.height * 2
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        
        // рассчитаем ширину
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        // рассчитываем высоту
        // с учетом нижнего отступа
        let bottomPadding = getSafeArea(.bottom)
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        // изменяем стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    // MARK: Cards generation
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
        flipHandler(&cardViews)
//        for card in cardViews {
//            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
//                // переносим карточку вверх иерархии
//                flippedCard.superview?.bringSubviewToFront(flippedCard)
//
//                // добавляем или удаляем карточку
//                if flippedCard.isFlipped {
//                    changeFlipCounterValue()
//                    self.flippedCards.append(flippedCard)
//                } else {
//                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
//                        self.flippedCards.remove(at: cardIndex)
//                    }
//                }
//                // если перевернуто 2 карточки
//                if self.flippedCards.count == 2 {
//                    compareTwoCards()
//
//                } else if self.flippedCards.count > 2 { // если перевернуто больше двух, то переворачиваем все карты рубашкой вверх
//                    flipAllCards()
//                }
//            }
//        }
//        game.flippedCardsCount = flippedCards.count
        
        return cardViews
    }
    
    // MARK: - Cards Generation from Last Game
    private func getCardsBy(storeData: [Card]) -> [UIView] {
        // хранилище для представлений карточек
        var cardViews = [UIView]()
        // фабрика карточек
        let cardViewFactory = CardViewFactory()
        // перебираем массив карточек из Core Data
        for cardData in storeData {
            // создаем только один уникальный экземпляр карты
            let card = cardViewFactory.get(cardData.type, withSize: cardSize, andColor: cardData.color)
            // добавляет tag (по которому происходит сравнение)
            // !!! подумать, как можно сделать более оптимальное сравнение
            card.tag = cardData.tag
            cardViews.append(card)
        }
        
        flipHandler(&cardViews)
     
        return cardViews
    }
    
    // MARK: - Flip handler
    // добавляем всем картам обработчик переворота
    private func flipHandler(_ cardViews: inout [UIView]) {
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

                } else if self.flippedCards.count > 2 { // если перевернуто больше двух, то переворачиваем все карты рубашкой вверх
                    flipAllCards()
                }
            }
        }
    }
    
    // MARK: - Change Flip Counter
    private func changeFlipCounterValue() {
        let currentFlipCount = Int(flipCounterLabel.text ?? "0") ?? 0
        
        flipCounterLabel.text = String(currentFlipCount + 1)
    }
    
    // MARK: - Compare Cards
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
            // вычитаем две совпавшие карты из общего количества карт
            cardsInGame -= 2
            // в ином случае
        } else {
            // переворачиваем карточки рубашкой вверх
            for card in self.flippedCards {
                (card as! FlippableView).flip()
            }
        }
        // проверяем окончание игры
        checkEndGame()
    }
    
    // MARK: - Set Settings
    private func setPairsCardsCount() -> Int {
        if UserDefaults.standard.object(forKey: "Pairs cards count") == nil {
            let startPairsCardsCount = 4
            
            UserDefaults.standard.set(startPairsCardsCount, forKey: "Pairs cards count")
            
            return startPairsCardsCount
        }
        
        return Int(UserDefaults.standard.object(forKey: "Pairs cards count") as! Double)
    }
    
    // MARK: - Put cards on Board
    private func placeCardsOnBoard(_ cards: [UIView]) {
        // координаты карточки
        var randomXCoordinate = 0
        var randomYCoordinate = 0
        // удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        flippedCards = []
        cardViews = cards
        // перебираем карточки
        for card in cardViews {
            // для каждой карточки генерируем случайные координаты
            randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            // размещаем карточку на игровом поле
            boardGameView.addSubview(card)
        }
    }
    
    private func placeCardsOnBoardFromLastGame(_ cards: [UIView]) {
        cardViews = cards
        // 0. создать карточки по данным из Core Data

        // 1. перебираем все карточки
        for (i, card) in game.exampleCards.enumerated() {
            // 2. получаем координаты карточки из Core Data
            print("x: \(card.coordinateX), y: \(card.coordinateY)")
            // 3. каждой карточке присваиваем координаты из Core Data
            cardViews[i].frame.origin = CGPoint(x: card.coordinateX, y: card.coordinateY)
            // если карточка была перевернута в прошлой игре, то переворачиваем ее тоже
            if card.isFlipped {
                (cardViews[i] as! FlippableView).isFlipped = true
                flippedCards.append(cardViews[i])
            }
            // 4. размещаем карточку на игровом поле
            boardGameView.addSubview(cardViews[i])
        }
    }
    
    // MARK: - Flip All Cards
    private func flipAllCards() {
        if flippedCards.isEmpty || flippedCards.count == 1 {
            for card in cardViews {
                (card as! FlippableView).isFlipped = true
                flippedCards.append(card)
            }
            let currVal = Int(flipCounterLabel.text ?? "0") ?? 0
            
            flipCounterLabel.text = String(currVal + cardsInGame)
        } else if !flippedCards.isEmpty {
            for card in cardViews {
                (card as! FlippableView).isFlipped = false
            }
            flippedCards = []
        }
    }
    
    // MARK: - End Game Methods
    private func checkEndGame() {
        if cardsInGame == 0 {
            print("You Won!")
            // show an alert with flip's count
            let alert = UIAlertController(title: "The Game is End!", message: "You found all cards by \(flipCounterLabel.text ?? "0") flips.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            let startNewGameAction = UIAlertAction(title: "New Game", style: .destructive) { _ in
                self.startGame(self.startButtonView)
            }
            alert.addAction(action)
            alert.addAction(startNewGameAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Core Data
    // find or create the last game data in Core Data
    func loadOrCreateLastGame() {
        let gameName = "Last Game"
        let gameFetch: NSFetchRequest<GameData> = GameData.fetchRequest()
        
        gameFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(GameData.name), gameName)
        
        do {
            let results = try coreDataStack.managedContext.fetch(gameFetch)
            if results.isEmpty {
                // Last Game is not found, create Last Game
                currentGame = GameData(context: coreDataStack.managedContext)
                currentGame?.name = gameName
                coreDataStack.saveContext()
                print("Last Game is not found, create Last Game")
            } else {
                // Last Game is found, use Last Game
                currentGame = results.first
                print("Last Game is found, use Last Game")
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
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
    
    // MARK: - Actions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        game = startNewGame()
        let cards = getCardsBy(modelData: game.cards)
        // try to get only one pair
        
        placeCardsOnBoard(cards)
    }
    
    @IBAction func flipAllButtonPressed(_ sender: UIButton) {
        flipAllCards()
        
        print("Flipp All button pressed.")
    }
    
    // MARK: - Extensions
    func getSafeArea(_ area: SafeAreaInsets) -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        switch area {
        case .top:
            return (keyWindow?.safeAreaInsets.top)!
        case .left:
            return (keyWindow?.safeAreaInsets.left)!
        case .right:
            return (keyWindow?.safeAreaInsets.right)!
        case .bottom:
            return (keyWindow?.safeAreaInsets.bottom)!
        }
    }
    
    enum SafeAreaInsets {
        case top, left, right, bottom
    }
}
