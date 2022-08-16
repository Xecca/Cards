//
//  BoardGameViewController.swift
//  Cards
//
//  Created by Dreik on 6/23/22.
//

import UIKit
import CoreData

protocol BoardGameViewDelegate: NSObjectProtocol {
    func displayBoardGameScreen()
}

class BoardGameViewController: UIViewController {
    
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
        
        setTimerLabel()
        
        if isContinue == true {
            // retrieve data about last game from Core Data
            loadOrCreateLastGame()
            game = continueLastGame()
            print("Continue last game in viewDidLoad")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        saveLastGameToCoreData()
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
        
        // add all cards from current gate to the CardData's array
        for cardView in cardViews {
            let card = CardData(context: coreDataStack.managedContext)
            
            card.coordinateX = Int32(cardView.key.frame.origin.x)
            card.coordinateY = Int32(cardView.key.frame.origin.y)
            card.isFlipped = cardView.value.isFlipped
            // TODO: - add feature to save backSideFigure to CoreData
            //            card.backSideFigure = cardView.value.backFigure
            card.backSideFigure = "circle"
            card.frontSideFigure = getFigureTypeStringFrom(type: cardView.value.type)
            card.frontFigureColor = getFigureColorStringFrom(color: cardView.value.color)
            card.tag = Int32(cardView.value.tag)
            
            cardsBeforeAddingToCoreData.append(card)
        }
        currentGame?.cards = nil
        print("currentGame.cards.count after emptying: \(currentGame?.cards?.set.count ?? 0)")
        
        // Insert the new Card into the GameData's cards set
        if let gameData = currentGame, let cards = gameData.cards?.mutableCopy() as? NSMutableOrderedSet {
            for cardInArr in cardsBeforeAddingToCoreData {
                print("cardInArr = \(cardInArr.tag)")
                cards.add(cardInArr)
            }
            gameData.cards = cards
            gameData.flipsCount = Int32(flipCounterLabel.text ?? "0") ?? 0
            gameData.time = 0
            print("added card data into CoreData!")
        }
        coreDataStack.saveContext()
        print("Data saved to Core Data!")
    }
    
    // MARK: - Side Menu Button action
    @objc func didTapMenuButton() {
        print("menu batton tapped")
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
        
        // NOTE: Show timer animation and at the end flip all cards back
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

        timerLabel.alpha = 0.0
        timerLabel.font = timerLabel.font.withSize(120)
        timerLabel.textColor = .blue
    }
    
    @objc private func showTimer(_ timerInSeconds: String) {
        boardGameView.bringSubviewToFront(timerLabel)
        timerLabel.isHidden = false
        // NOTE: - set label's position on the middle of board
        timerLabel.center.x = view.frame.width - 40
        timerLabel.center.y = view.frame.height / 3 - 40
        timerLabel.text = "\(timerInSeconds)"
        print("\(timerInSeconds)")
        
        UILabel.animate(
            withDuration: 1.0,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                // make label appear
                self.timerLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.timerLabel.alpha = 1.0
                self.timerLabel.transform = .identity
                
            }
        )
        // make label disappear
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
        
        guard let currentGameCards = currentGame?.cards else {
            return Game()
        }
        
        game.cardsCount = currentGameCards.count
        print("cards count in ContinueLastGame: \(game.cardsCount)")
        game.generateCardsFromCoreData(currentGame)
        
        flipCounterLabel.text = "\(currentGame?.flipsCount ?? 0)"
        cardsInGame = game.cards.count
        
        isGameStarted = true
        
        let cards = getCardsBy(storeData: game.cards)
        placeCardsOnBoardFromLastGame(cards)
        
        return game
    }
    
    // MARK: - Save Last Game Data
    private func saveLastGameToCoreData() {
        loadOrCreateLastGame()
        insertCardsDataIntoCoreData()
    }
    
    // MARK: - Board View
    private func getBoardGameView() -> UIView {
        let margin: CGFloat = 10
        let boardView = UIView()
        // set coordinates for boardView
        // x
        boardView.frame.origin.x = margin
        let topPadding = getSafeArea(.top) + startButtonView.frame.height * 2
        // y
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        // set width
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        // set height
        let bottomPadding = getSafeArea(.bottom)
        
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        // style
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    // MARK: Cards generation
    private func getCardsBy(modelData: [Card]) -> [UIView: Card] {
        var cardViewDict: [UIView: Card] = [:]
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = CardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            
            cardOne.tag = index
            cardViewDict[cardOne] = (type: modelCard.type, color: modelCard.color, coordinateX: modelCard.coordinateX, coordinateY: modelCard.coordinateY, isFlipped: modelCard.isFlipped, tag: index)
            
            let cardTwo = CardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            
            cardTwo.tag = index
            cardViewDict[cardTwo] = (type: modelCard.type, color: modelCard.color, coordinateX: modelCard.coordinateX, coordinateY: modelCard.coordinateY, isFlipped: modelCard.isFlipped, tag: index)
        }
        // add to each card a flip handler
        flipHandler(&cardViewDict)
        
        return cardViewDict
    }
    
    // MARK: - Cards Generation from Last Game
    private func getCardsBy(storeData: [Card]) -> [UIView: Card] {
        var cardViews = [UIView: Card]()
        
        for cardData in storeData {
            let card = CardViewFactory.get(cardData.type, withSize: cardSize, andColor: cardData.color)
            
            card.tag = cardData.tag
            cardViews[card] = cardData
        }
        
        flipHandler(&cardViews)
        
        return cardViews
    }
    
    // MARK: - Flip handler
    private func flipHandler(_ cardViews: inout [UIView: Card]) {
        for card in cardViews.keys {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                // move card on the top of hierarchy
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                // add or delete a card
                if flippedCard.isFlipped {
                    changeFlipCounterValue()
                    self.flippedCards.append(flippedCard)
                    self.cardViews[card]?.isFlipped = true
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                if self.flippedCards.count == 2 {
                    compareTwoCards()
                } else if self.flippedCards.count > 2 {
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
        let firstCard = game.cards[self.flippedCards.first!.tag]
        let secondCard = game.cards[self.flippedCards.last!.tag]
        
        if game.compareTwoCards(firstCard, secondCard) {
            // hide them with animation
            UIView.animate(withDuration: 0.3, animations: {
                self.flippedCards.first!.layer.opacity = 0
                self.flippedCards.last!.layer.opacity = 0
                // after delete them from hierarchy
            }, completion: { _ in
                // FIXME: sometimes here an error happens
                self.flippedCards.first!.removeFromSuperview()
                // ---
                self.flippedCards.last!.removeFromSuperview()
                self.flippedCards = []
            })
            cardsInGame -= 2
            cardViews[flippedCards.first!] = nil
            cardViews[flippedCards.last!] = nil
        } else {
            for card in self.flippedCards {
                (card as! FlippableView).flip()
            }
        }
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
        var randomXCoordinate = 0
        var randomYCoordinate = 0
        // remove all cards from board
        for card in cardViews {
            card.key.removeFromSuperview()
        }
        flippedCards = []
        cardViews = cards
        
        for card in cardViews {
            randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.key.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            
            boardGameView.addSubview(card.key)
        }
        showAllCardsAndCounter()
    }
    
    private func placeCardsOnBoardFromLastGame(_ cards: [UIView: Card]) {
        guard let currentGameCards = currentGame?.cards as? NSMutableOrderedSet else {
            return
        }
        
        if cards.count == currentGameCards.count {
            for card in cards {
                let cardForPresent = card.key
                
                cardForPresent.frame.origin.x = CGFloat(card.value.coordinateX)
                cardForPresent.frame.origin.y = CGFloat(card.value.coordinateY)
                cardForPresent.tag = card.value.tag
                
                if cards[cardForPresent]?.isFlipped == true {
                    (cardForPresent as! FlippableView).isFlipped = true
                    flippedCards.append(cardForPresent)
                } else {
                    (cardForPresent as! FlippableView).isFlipped = false
                }
                
                boardGameView.addSubview(cardForPresent)
            }
            cardViews = cards
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
    
    // MARK: - Actions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        
        placeCardsOnBoard(cards)
    }
    
    @IBAction func flipAllButtonPressed(_ sender: UIButton) {
        // FIXME: - sometimes when the game continues flipAll works only on the second try
        flipAllCards()
        print("Flipp All button pressed.")
    }
}

// MARK: - Extensions
extension BoardGameViewController {
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
