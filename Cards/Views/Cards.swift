//
//  Cards.swift
//  Cards
//
//  Created by Dreik on 6/18/22.
//

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

// MARK: - Card Generation
class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    var color: UIColor!
    private let margin: Int = 10
    var cornerRadius = 20
    lazy var frontSideView: UIView = self.getFrontSideView()
    lazy var backSideView: UIView = self.getBackSideView()
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        
        setupBorders()
    }
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        // delete previous added views
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        // add new views
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
        let shapeView = UIView(frame: CGRect(x: margin, y: margin, width: Int(self.bounds.width) - margin * 2, height: Int(self.bounds.height) - margin * 2))
        
        view.addSubview(shapeView)
        
        // make round corners for root layer
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        // create layer with figure
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        return view
    }
    // MARK: - BackSide View
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
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
        
        // make round corners for root layer
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    // MARK: - Animations
    func flip() {
        // define between which views make transition
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop], completion: { _ in
            self.flipCompletionHandler?(self)
        })
        isFlipped.toggle()
    }
    
    func rotateView() {
        // flip view
        if self.transform.isIdentity {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        } else {
            self.transform = .identity
        }
    }
    
    // MARK: Events
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var startTouchPoint: CGPoint!
    
    func checkBoardersAndReturnCardBack() {
        // if it hits the boundary of the playing field on the right
        if self.frame.origin.x + self.frame.width > superview!.frame.width {
            UIView.animate(withDuration: 0.5) {
                self.frame.origin.x = self.superview!.frame.width - self.frame.width - 5
            }
        }
        // if it hits the boundary of the playing field on the left
        if self.frame.origin.x < superview!.bounds.origin.x {
            UIView.animate(withDuration: 0.5) {
                self.frame.origin.x = self.superview!.frame.origin.x - CGFloat(self.margin) + 5
            }
        }
        // if it hits the bottom of the playing field
        if self.frame.origin.y + self.frame.height > superview!.bounds.height {
            UIView.animate(withDuration: 0.5) {
                self.frame.origin.y = self.superview!.frame.height - self.frame.height - 5
            }
        }
        // if it hits the boundary of the playing field from above
        if superview!.bounds.origin.y > self.frame.origin.y {
            UIView.animate(withDuration: 0.5) {
                self.frame.origin.y = 5
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        
        startTouchPoint = frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
            flip()
        }
        checkBoardersAndReturnCardBack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

