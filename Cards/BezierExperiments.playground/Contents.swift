//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

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
//        shapeLayer.fillColor = UIColor.green.cgColor
//        // убрать цвет заполнения
        shapeLayer.fillColor = nil
//        // or
//        shaperLayer.fillColor = UIColor.clear.cgColor
        // изменение формы конечных точек фигуры
        shapeLayer.lineCap = .round
        // делаем фигуру прирывистой
        shapeLayer.lineDashPattern = [3, 5, 15]
        
        // 4. создание фигуры
        shapeLayer.path = getPath().cgPath
    }
    
    private func getPath() -> UIBezierPath {
        // 1
        let path = UIBezierPath()
        // 2
        path.move(to: CGPoint(x: 50, y: 50))
        // 3
        path.addLine(to: CGPoint(x: 150, y: 50))
        // создание второй линии
        path.addLine(to: CGPoint(x: 150, y: 150))
        
        return path
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
