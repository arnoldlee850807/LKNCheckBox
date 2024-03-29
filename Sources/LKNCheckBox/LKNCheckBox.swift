import UIKit

fileprivate extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//  MARK: - LKNCheckBox
public class LKNCheckBox: UIView{
        
    let button = UIButton()
    let baseView = UIView()
    let circleBezier = UIView()
    var shapeLayerOne: CAShapeLayer?
    let topView = UIView()
    let path = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    let hookPath = UIBezierPath()
    let hookShapeLayer = CAShapeLayer()
    var lineWidth = CGFloat(0)
    public var lineColor: CGColor = UIColor(hexString: "#01b7b7").cgColor
    
    override public func draw(_ rect: CGRect) {
        button.frame = frame.width >= frame.height ? CGRect(x: 0, y: 0, width: frame.height, height: frame.height):CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        
        
        lineWidth = frame.height / 22
        baseView.frame = button.frame
        
        addSubview(baseView)
        baseView.backgroundColor = .clear
        baseView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        circleBezier.frame = CGRect(x: 0, y: 0, width: button.frame.width + lineWidth, height: button.frame.height + lineWidth)
        circleBezier.layer.cornerRadius = circleBezier.frame.width / 2
        circleBezier.layer.masksToBounds = true
        circleBezier.layer.borderWidth = lineWidth
        circleBezier.layer.borderColor = UIColor.lightGray.cgColor
        circleBezier.backgroundColor = .clear
        addSubview(circleBezier)
        circleBezier.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        
        topView.frame = button.frame
        topView.backgroundColor = .clear
        addSubview(topView)
        topView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        addSubview(button)
        
        path.addArc(withCenter: button.center, radius: button.frame.width / 2, startAngle: -CGFloat.pi / 4, endAngle: CGFloat.pi*7/4, clockwise: true)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = path.cgPath
        shapeLayer.strokeEnd = 0
        topView.layer.addSublayer(shapeLayer)
        
        hookPath.move(to: CGPoint(x: button.center.x - button.frame.width / 4, y: button.center.y - button.frame.height / 12 + button.frame.height / 20))
        hookPath.addLine(to: CGPoint(x: button.center.x, y: button.center.y + button.frame.height / 8 + button.frame.height / 20))
        hookPath.addLine(to: CGPoint(x: button.center.x + button.frame.width / 4, y: button.center.y - button.frame.height / 4 + button.frame.height / 20))
        hookShapeLayer.fillColor = UIColor.clear.cgColor
        hookShapeLayer.strokeColor = lineColor
        hookShapeLayer.lineWidth = lineWidth
        hookShapeLayer.path = hookPath.cgPath
        hookShapeLayer.strokeEnd = 0
        topView.layer.addSublayer(hookShapeLayer)
        
    }
    public private(set) var set = false
    
    @objc func buttonPressed(){
        if set{
            shapeLayer.strokeEnd = 0
            hookShapeLayer.strokeEnd = 0
            reDraw()
        }
        else{
            shapeLayer.strokeEnd = 1.0
            hookShapeLayer.strokeEnd = 1.0
            draw()
        }
        set = !set
    }
    
    func draw(){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = CFTimeInterval(0.6)
        shapeLayer.add(animation, forKey: "animateCircle")
        let hookAnimation = CABasicAnimation(keyPath: "strokeEnd")
        hookAnimation.fromValue = 0
        hookAnimation.duration = CFTimeInterval(0.6)
        hookShapeLayer.add(animation, forKey: "MyAnimation")
    }
    
    func reDraw(){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = shapeLayer.presentation()?.strokeEnd
        animation.toValue = 0.0
        animation.duration = CFTimeInterval(0.6)
        shapeLayer.removeAllAnimations()
        shapeLayer.add(animation, forKey: "animateCircle")
        let hookAnimation = CABasicAnimation(keyPath: "strokeEnd")
        hookAnimation.fromValue = hookShapeLayer.presentation()?.strokeEnd
        hookAnimation.toValue = 0
        hookAnimation.duration = CFTimeInterval(0.6)
        hookShapeLayer.removeAllAnimations()
        hookShapeLayer.add(animation, forKey: "MyAnimation")
    }
}
