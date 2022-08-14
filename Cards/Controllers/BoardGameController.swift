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
    @IBOutlet weak var flipAllButton: UIButton!
    let timerLabel = UILabel()
    
    lazy var isContinue = false
    lazy var game: Game = getNewGame()
    lazy var boardGameView = getBoardGameView()
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
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
     var cardViews = [UIView: Card]()
    private var flippedCards = [UIView]()
    // Core Data
    lazy var coreDataStack = CoreDataStack(modelName: "Cards")
    var currentGame: GameData?
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(boardGameView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // устанавливаем настройки таймера
        setTimerLabel()
        // провераяем по какой кнопке пришли на экран игры
        if isContinue == true {
            // retrieve data about last game from Core Data
            loadOrCreateLastGame()
            game = continueLastGame()
            print("Continue last game in viewDidLoad")
        }
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Сохраняем данные текущей игры в CoreData
        
        saveLastGame()
        
        // 1. количество переворотов
        // 1.1. время, затраченное на игру
        // 2. Координаты каждой карты
        // 3. Цвета и тип фигуры лицевой стороны карты
        print("viewWillDisappear")
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
    
    func insertCardsDataIntoCoreData() {
        // Insert a new Card entity into Core Data
        
        // массив [CardData]
        var cardsBeforeAddingToCoreData: [CardData] = []

        // добавить все карты из текущей игры в массив CardData
        for cardView in cardViews {
            let card = CardData(context: coreDataStack.managedContext)
            
            card.coordinateX = Int32(cardView.key.frame.origin.x)
            card.coordinateY = Int32(cardView.key.frame.origin.y)
            // fix this
            print("card.isFlipped from current game \(cardView.value.isFlipped)")
            card.isFlipped = cardView.value.isFlipped
//            card.backSideFigure = cardView.value.backFigure
            card.backSideFigure = "circle"
            card.frontSideFigure = getFigureTypeStringFrom(type: cardView.value.type)
//            card.frontSideFigure = "fill"
            card.frontFigureColor = getFigureColorStringFrom(color: cardView.value.color)
            card.tag = Int32(cardView.value.tag)
            
            print("Card type in insertCardsDataIntoCoreData before adding: \(String(describing: card.frontSideFigure))")
            print("Card tag in insertCardsDataIntoCoreData before adding: \(String(describing: card.tag))")
            print("Card coordinateX in insertCardsDataIntoCoreData before adding: \(String(describing: card.coordinateX))")
            
            cardsBeforeAddingToCoreData.append(card)
        }
        
        // перед тем, как добавлять карты из текущей игры, нужно очистить карты из предыдущей
        currentGame?.cards = nil
        print("currentGame.cards.count after emptying: \(currentGame?.cards?.set.count ?? 0)")
        
//        print(card.coordinateX)
        
        // Insert the new Card into the GameData's cards set
        if let gameData = currentGame, let cards = gameData.cards?.mutableCopy() as? NSMutableOrderedSet {
            for cardInArr in cardsBeforeAddingToCoreData {
                print("cardInArr = \(cardInArr.tag)")
                cards.add(cardInArr)
            }
//            cards.add(card)
            gameData.cards = cards
//            gameData.cards = cardsBeforeAddingToCoreData
            gameData.flipsCount = Int32(flipCounterLabel.text ?? "0") ?? 0
            gameData.time = 0
            print("added card data into CoreData!")
        }
        
        // Save the managed object context
        coreDataStack.saveContext()
        print("Data saved to Core Data!")

        // Reload data
        //
    }
    
    // MARK: - Side Menu Button action
    @objc func didTapMenuButton() {
        print("menu batton tapped")
//        self.didTapMenuButton()
    }
    
    // MARK: Start New Game
    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)

    }
    
    private func getNewGame() -> Game {
        let game = Game()
        
        game.cardsCount = cardsPairsCount
        game.generateCards()
        
        flipCounterLabel.text = "0"
        cardsInGame = game.cardsCount * 2
        isGameStarted = true
        
        return game
    }
    
    private func showAllCardsAndCounter() {
        print("in showAllCardsAndCounter before dispatchQueue")
        flipAllCards()
        flipCounterLabel.text = "0"
        
        // NOTE: Выводим анимацию отсчета и в конце переворачиваем карты обратно
        startButtonView.isEnabled = false
        flipAllButton.isEnabled = false
        var counts = 3
        var i = 1
        while counts > 0 {
            perform(#selector(showTimer(_:)), with: "\(counts)", afterDelay: TimeInterval(i))
            counts -= 1
            i += 1
        }
        perform(#selector(showTimer(_:)), with: "Go!", afterDelay: TimeInterval(i))

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(4500)) {
            self.flipAllCards()
            print("after 4 seconds")
            self.startButtonView.isEnabled = true
            self.flipAllButton.isEnabled = true
            self.timerLabel.isHidden = true
        }
    }
    
    func setTimerLabel() {
        boardGameView.addSubview(timerLabel)
        timerLabel.isHidden = true
        timerLabel.frame.size.width = 360
        timerLabel.frame.size.height = 150

        // NOTE: устанавливаем прозрачность и размер шрифта/label
        timerLabel.alpha = 0.0
        timerLabel.font = timerLabel.font.withSize(120)
        timerLabel.textColor = .blue
    }
    
    // Показываем анимацию отсчета
    @objc private func showTimer(_ timerInSeconds: String) {
        boardGameView.bringSubviewToFront(timerLabel)
        timerLabel.isHidden = false
        // NOTE: устанавливаем позицую label по центру игрового поля
        timerLabel.center.x = view.frame.width - 40
        timerLabel.center.y = view.frame.height / 3 - 40
        timerLabel.text = "\(timerInSeconds)"
        print("\(timerInSeconds)")
        
        UILabel.animate(
            withDuration: 1.0,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                // устанавливаем прозрачность и размер мяча возвращая их к нормальному состоянию
                self.timerLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.timerLabel.alpha = 1.0
                self.timerLabel.transform = .identity
                
            }
        )
//         NOTE: делаем изчезновение label
        UILabel.animate(
            withDuration: 0.3,
            delay: 0.8,
            options: .curveEaseOut,
            animations: {
                // устанавливаем прозрачность и размер label
                self.timerLabel.transform = CGAffineTransform(scaleX: -0.4, y: -0.4)    // rotate label
                self.timerLabel.alpha = 0.0
                self.timerLabel.transform = .identity
            }
        )
    }
    
    // MARK: - Continue Last Game
    private func continueLastGame() -> Game {
        print("Continue Last Game")
        let game = Game()
        loadOrCreateLastGame()
        
        guard let currentGameCard = currentGame?.cards else {
            return Game()
        }
        
        game.cardsCount = currentGameCard.count
        print("cards count in ContinueLastGame: \(game.cardsCount)")    // 14
        game.generateCardsFromCoreData(currentGame)
    
        flipCounterLabel.text = "\(currentGame?.flipsCount ?? 0)"
        cardsInGame = game.cards.count
        
        isGameStarted = true
        
        let cards = getCardsBy(storeData: game.cards)
        placeCardsOnBoardFromLastGame(cards)
        
        return game
    }
    
    // MARK: - Save Last Game Data
    private func saveLastGame() {
        loadOrCreateLastGame()
        insertCardsDataIntoCoreData()
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
    private func getCardsBy(modelData: [Card]) -> [UIView: Card] {
        // хранилище для представлений карточек
        var cardViewDict: [UIView: Card] = [:]
        // перебираем массив карточек в Модели
        for (index, modelCard) in modelData.enumerated() {
            // добавляем первый экземпляр карты
            let cardOne = CardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
//            cardViews.append(cardOne)
            // добавляем данные карты в словарь
            cardViewDict[cardOne] = (type: modelCard.type, color: modelCard.color, coordinateX: modelCard.coordinateX, coordinateY: modelCard.coordinateY, isFlipped: modelCard.isFlipped, tag: index)
            
            // добавляем второй экземпляр карты
            let cardTwo = CardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            // добавляем данные второй карты в словарь
            cardViewDict[cardTwo] = (type: modelCard.type, color: modelCard.color, coordinateX: modelCard.coordinateX, coordinateY: modelCard.coordinateY, isFlipped: modelCard.isFlipped, tag: index)
        }
        // добавляем всем картам обработчик переворота
        flipHandler(&cardViewDict)
        
        return cardViewDict
    }
    
    // MARK: - Cards Generation from Last Game
    private func getCardsBy(storeData: [Card]) -> [UIView: Card] {
        // хранилище для представлений карточек
        var cardViews = [UIView: Card]()
        // перебираем массив карточек из Core Data
        for cardData in storeData {
            // создаем только один уникальный экземпляр карты
            print("card type in getCardsBy from CoreData: \(cardData.type)")
            
            let card = CardViewFactory.get(cardData.type, withSize: cardSize, andColor: cardData.color)
            // добавляет tag (по которому происходит сравнение)
            // !!! подумать, как можно сделать более оптимальное сравнение
            card.tag = cardData.tag
            cardViews[card] = cardData
        }
        
        flipHandler(&cardViews)
     
        return cardViews
    }
    
    // MARK: - Flip handler
    // добавляем всем картам обработчик переворота
    private func flipHandler(_ cardViews: inout [UIView: Card]) {
        for card in cardViews.keys {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                // переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                // добавляем или удаляем карточку
                if flippedCard.isFlipped {
                    changeFlipCounterValue()
                    self.flippedCards.append(flippedCard)
                    self.cardViews[card]?.isFlipped = true
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
            // удаляем совпавшеие карты из cardViews, иначе воспроизводится первоначальное количество карт
//            let firstCardIndex = cardViews.firstIndex(of: flippedCards.first!) ?? 0
//            cardViews.remove(at: firstCardIndex)
            cardViews[flippedCards.first!] = nil
            cardViews[flippedCards.last!] = nil
            // Переделать flippedCards в словарь
//            let secondCardIndex = cardViews.firstIndex(of: flippedCards.last!) ?? 0
//            cardViews.remove(at: secondCardIndex)
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
    private func placeCardsOnBoard(_ cards: [UIView: Card]) {
        // координаты карточки
        var randomXCoordinate = 0
        var randomYCoordinate = 0
        // удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.key.removeFromSuperview()
        }
        flippedCards = []
        cardViews = cards
        // перебираем карточки
        for card in cardViews {
            // для каждой карточки генерируем случайные координаты
            randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.key.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            // размещаем карточку на игровом поле
            boardGameView.addSubview(card.key)
        }
        showAllCardsAndCounter()
    }
    
    private func placeCardsOnBoardFromLastGame(_ cards: [UIView: Card]) {
        cardViews = cards
        // 0. создать карточки по данным из Core Data
        
        print("Cards count in placeCardsOnBoardFromLastGame: \(cards.count)")

        guard let currentGameCards = currentGame?.cards as? NSMutableOrderedSet else {
            return
        }

        if cardViews.count == currentGameCards.count {
            // создаем массив view
            var cardOnlyViews = [UIView]()
            
            for card in cardViews {
                cardOnlyViews.append(card.key)
            }
            
            // 1. перебираем все карточки
            for (i, card) in currentGameCards.enumerated() {
                // 2. получаем координаты карточки из Core Data
    //            print("x: \(card.coordinateX), y: \(card.coordinateY)")
                // 3. каждой карточке присваиваем координаты из Core Data
                
                guard let card = card as? CardData else {
                    return
                }
                
                print(card.frontSideFigure!)
                
                cardOnlyViews[i].frame.origin = CGPoint(x: CGFloat(card.coordinateX) , y: CGFloat(card.coordinateY))
                
//                print(cardViews[i].frontFigureType)
                
                // если карточка была перевернута в прошлой игре, то переворачиваем ее тоже
                if cardViews[cardOnlyViews[i]]?.isFlipped == true {
                    (cardOnlyViews[i] as! FlippableView).isFlipped = true
                    print("Should flip the card!")
                } else {
                    (cardOnlyViews[i] as! FlippableView).isFlipped = false
                    print("Should flip the card! But in")
                }
                flippedCards.append(cardOnlyViews[i])
                // 4. размещаем карточку на игровом поле
                boardGameView.addSubview(cardOnlyViews[i])
            }
        }
    }
    
    // MARK: - Flip All Cards
    private func flipAllCards() {
        if flippedCards.isEmpty || flippedCards.count == 1 {
            for card in cardViews {
                (card.key as! FlippableView).isFlipped = true
                flippedCards.append(card.key)
                cardViews[card.key]?.isFlipped = true
            }
            let currVal = Int(flipCounterLabel.text ?? "0") ?? 0
            
            flipCounterLabel.text = String(currVal + cardsInGame)
        } else if !flippedCards.isEmpty {
            for card in cardViews {
                (card.key as! FlippableView).isFlipped = false
                cardViews[card.key]?.isFlipped = false
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
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        // try to get only one pair
        
        placeCardsOnBoard(cards)
        
    }
    
    @IBAction func flipAllButtonPressed(_ sender: UIButton) {
        flipAllCards()
        
        print("Flipp All button pressed.")
    }
}

    // MARK: - Extensions
extension BoardGameController {
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
