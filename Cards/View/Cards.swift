//
//  Cards.swift
//  Cards
//
//  Created by Dreik on 5/5/22.
//

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    // цвет фигуры
    var color: UIColor!
    // внутренний отступ представления
    private let margin: Int = 10
    // радиус скругления
    var cornerRadius = 20
    
    
    // представление с лицевой стороны карты
    lazy var frontSideView: UIView = self.getFrontSideView()
    // представление с обратной стороны карты
    lazy var backSideView: UIView = self.getBackSideView()
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        
        setupBorders()
    }
    
    override func draw(_ rect: CGRect) {
        // удаляем добавленные ранее дочерние представления
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        // добавляем новые представления
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    // настройка границ
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    // возвращает представление для лицевой стороны карточки
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
        let shapeView = UIView(frame: CGRect(x: margin, y: margin, width: Int(self.bounds.width) - margin * 2, height: Int(self.bounds.height) - margin * 2))
        
        view.addSubview(shapeView)
        
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        // создание слоя с фигурой
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        return view
    }
    
    // возвращает вью для обратной стороны карточки
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
        // выбор случайного узора для рубашки
        switch ["circle", "line"].randomElement()! {
        case "circle":
            let layer = BackSideCircles(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLines(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    func flip() {
        // определяем, между какими представлениями осуществить переход
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        
        // запускаем анимированный переход
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop], completion: { _ in
            // обработчик переворота
            self.flipCompletionHandler?(self)
        })
        isFlipped = !isFlipped
    }
    
    // MARK: Events
    
    // точка привязки
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    // исходные координаты игральной карты
    private var startTouchPoint: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // изменяем координаты точки привязки
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        
        // сохраняем исходные координаты
        startTouchPoint = frame.origin
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // анимировано возвращаем карточку в исходную позицию
//        UIView.animate(withDuration: 0.5) { // 0.5 секунд
//            self.frame.origin = self.startTouchPoint
//        }
        
        // добавим проверку перемещения карточки
        if self.frame.origin == startTouchPoint {
//            // переворачиваем представление
//            if self.transform.isIdentity {
//                self.transform = CGAffineTransform(rotationAngle: .pi)
//            } else {
//                self.transform = .identity
//            }
            flip()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
