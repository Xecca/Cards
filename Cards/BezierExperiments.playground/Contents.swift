//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import CoreGraphics

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        // создаем кривые на сцене
        createBezier(on: view)
    }
    
    private func createBezier(on view: UIView) {
        // 1. создаем графический контекст (слой)
        // на нем в дальнейшем будут рисоваться кривые
        let shapeLayer = CAShapeLayer()
        // 2. добавляем слой в качестве дочернего к корневому слою корневого представления
        //
        view.layer.addSublayer(shapeLayer)
        // 3. изменение цвета линий
        shapeLayer.strokeColor = UIColor.gray.cgColor
        // изменение толщины линий
        shapeLayer.lineWidth = 5
        // определения цвета заполнения фигуры
        shapeLayer.fillColor = UIColor.green.cgColor
//        // убрать цвет заполнения
//        shapeLayer.fillColor = nil
//        // or
//        shaperLayer.fillColor = UIColor.clear.cgColor
        // изменение формы конечных точек фигуры
        shapeLayer.lineCap = .round
        // делаем фигуру прирывистой
        shapeLayer.lineDashPattern = [3, 5, 15]
//        // смещаем начало и конец линии фигуры
//        shapeLayer.strokeStart = 0.2
//        shapeLayer.strokeEnd = 0.8
        // изменение стиля соединительных точек
        shapeLayer.lineJoin = .bevel
        
        
        // 4. создание фигуры
        shapeLayer.path = getPath().cgPath
    }
    
    private func getPath() -> UIBezierPath {
        let path = UIBezierPath()

        // создание первого треугольника
        path.move(to: CGPoint(x: 50, y: 50))
        path.addLine(to: CGPoint(x: 150, y: 50))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.close()
        // создание второго треугольника
        path.move(to: CGPoint(x: 50, y: 70))
        path.addLine(to: CGPoint(x: 150, y: 170))
        path.addLine(to: CGPoint(x: 50, y: 170))
        path.close()
        
//        path.append(createRect())
//        path.append(createOval())
//        path.append(createCurve())
        path.move(to: CGPoint(x: 100, y: 250))
        path.append(createCookHat())
        
        return path
    }
    
    private func createRect() -> UIBezierPath {
        let rect = CGRect(x: 10, y: 50, width: 200, height: 200)
//        let path = UIBezierPath(rect: rect)
        // прямоугольник со скругленными углами
//        let path = UIBezierPath(roundedRect: rect, cornerRadius: 30)
        // скруглить только необходимые углы
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomRight, .topLeft], cornerRadii: CGSize(width: 30, height: 0))
        
        return path
    }
    
    private func createOval() -> UIBezierPath {
        let rect = CGRect(x: 140, y: 100, width: 200, height: 100)
        let path = UIBezierPath(ovalIn: rect)
        
        return path
    }
    
    private func createCurve() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 10, y: 10))
        path.addCurve(to: CGPoint(x: 200, y: 200), controlPoint1: CGPoint(x: 200, y: 20), controlPoint2: CGPoint(x: 20, y: 200))
        
        return path
    }
    
    private func createCookHat() -> UIBezierPath {
        let path = UIBezierPath()
        
//        path.move(to: CGPoint(x: 100, y: 100))
        path.addArc(withCenter: CGPoint(x: 150, y: 100), radius: 50, startAngle: .pi, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: 220, y: 100))
        path.addArc(withCenter: CGPoint(x: 220, y: 150), radius: 50, startAngle: .pi*3/2, endAngle: .pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 200, y: 260))
        path.addLine(to: CGPoint(x: 100, y: 260))
        path.addLine(to: CGPoint(x: 100, y: 200))
        path.addLine(to: CGPoint(x: 80, y: 200))
        path.addArc(withCenter: CGPoint(x: 80, y: 150), radius: 50, startAngle: .pi/2, endAngle: .pi*3/2, clockwise: true)
        path.close()
        
        return path
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
