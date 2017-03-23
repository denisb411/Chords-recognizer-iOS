import UIKit

let π:CGFloat = CGFloat(M_PI)


@IBDesignable
class AnalogView: UIView {
    
    var delegate: ViewController?
    
    fileprivate let thickHorizontalLayer = CAShapeLayer()
    fileprivate let thinHorizontalLayer = CAShapeLayer()
    
    fileprivate let roundThinLayer = CAShapeLayer(layer: self)
    fileprivate let roundThickLayer = CAShapeLayer(layer: self)
    
    
    
    @IBInspectable var thickYCoord: CGFloat = 50.0
    @IBInspectable var thinYCoord: CGFloat = 52.5
    
    
    
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func configure() {
        
    
        
        
        
        
        
//        let thickDashesPath = UIBezierPath()
//        thickDashesPath.move(to: CGPoint(x: 0, y: thickYCoord)) //left
//        
//        thickDashesPath.addLine(to: CGPoint(x: 340, y: thickYCoord)) //right
//        
//        //thickHorizontalLayer.frame           = frame
//        thickHorizontalLayer.path            = thickDashesPath.cgPath
//        thickHorizontalLayer.strokeColor     = UIColor.black.cgColor //dashes color
//        thickHorizontalLayer.lineWidth       = 20
//        thickHorizontalLayer.lineDashPattern = [ 1, 83.5 ]
//        //thickHorizontalLayer.lineDashPhase   = 0.25
//        
//        self.layer.addSublayer(thickHorizontalLayer)
//        
//        let thinDashesPath = UIBezierPath()
//        thinDashesPath.move(to: CGPoint(x: 0, y: thinYCoord)) //esquerda
//        thinDashesPath.addLine(to: CGPoint(x: 340, y: thinYCoord)) //direita
//        
//        //thinHorizontalLayer.frame            = frame
//        thinHorizontalLayer.path             = thinDashesPath.cgPath
//        thinHorizontalLayer.strokeColor      = UIColor.black.cgColor
//        thinHorizontalLayer.lineWidth        = 15.0
//        thinHorizontalLayer.fillColor        = UIColor.clear.cgColor
//        thinHorizontalLayer.lineDashPattern  = [ 0.5, 7.95]
//        //thinHorizontalLayer.lineDashPhase    = 0.25
//        
//        self.layer.addSublayer(thinHorizontalLayer)
//        
//         //Define the center point of the view where you’ll rotate the arc around.
//        
//        
//        
//        
        
    }
    
    
//    override func draw(_ rect: CGRect) {
//        
//        // Define the center point of the view where you’ll rotate the arc around.
//        let center = CGPoint(x:bounds.width/2, y: bounds.height)
//        
//        // Calculate the radius based on the max dimension of the view.
//        var radius: CGFloat = max(bounds.width, bounds.height+50)
//        
//        // Define the thickness of the arc.
//        let arcWidth: CGFloat = 1
//        
//        // Define the start and end angles for the arc.
//        let startAngle: CGFloat = π
//        let endAngle: CGFloat = 2 * π
//        
//        // Create a path based on the center point, radius, and angles you just defined.
//        var path = UIBezierPath(arcCenter: center,
//                                radius: radius/2 - arcWidth/2,
//                                startAngle: startAngle,
//                                endAngle: endAngle,
//                                clockwise: true)
//        
//        path.lineWidth = arcWidth
//        counterColor.setStroke()
//        path.stroke()
//        
//        
//        
//        radius = max(bounds.width, bounds.height+70)
//    
//        path = UIBezierPath(arcCenter: center,
//                                radius: radius/2 - arcWidth/2,
//                                startAngle: startAngle,
//                                endAngle: endAngle,
//                                clockwise: true)
//        
//        let strokeColor            = UIColor.black.cgColor
//        
//        
//        roundThinLayer.path             = path.cgPath
//        roundThinLayer.strokeColor      = strokeColor
//        roundThinLayer.lineWidth        = 16.0
//        roundThinLayer.fillColor        = UIColor.clear.cgColor
//        roundThinLayer.lineDashPattern  = [ 0.5, 4.55 ]
//        //roundThinLayer.lineDashPhase    = 0.25
//        
//        
//        self.layer.addSublayer(roundThinLayer)
//        
//        
//        radius = max(bounds.width, bounds.height+90)
//        
//        path = UIBezierPath(arcCenter: center,
//                            radius: radius/2 - arcWidth/2,
//                            startAngle: startAngle,
//                            endAngle: endAngle,
//                            clockwise: true)
//        
//        roundThickLayer.path            = path.cgPath
//        roundThickLayer.strokeColor     = strokeColor
//        roundThickLayer.lineWidth       = 40
//        roundThickLayer.fillColor       = UIColor.clear.cgColor
//        roundThickLayer.lineDashPattern = [ 1.5, 140 ]
//        roundThickLayer.lineDashPhase   = 0.25
//        self.layer.addSublayer(roundThickLayer)
//        
//        
//    }
    public override func draw(_ rect: CGRect) {
        
        // Drawing the circle line
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height-60)
        var radius: CGFloat = max(bounds.width, bounds.height+50)
        let arcWidth: CGFloat = 1
        let startAngle: CGFloat = CGFloat(M_PI) // π
        let endAngle: CGFloat = CGFloat(2 * M_PI) // π
        let counterColor = UIColor.red
        
        var path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
        
        //Drawing a dot at the center
        
        let dotRadius = max(bounds.width/15, bounds.height/15)
        let dotWidth:CGFloat = 10
        let dotCenter = CGPoint(x:bounds.width/2, y: bounds.height-60)
        let dotStartAngle: CGFloat = 0
        let dotEndAngle: CGFloat = CGFloat(2 * M_PI) // π
        
        path = UIBezierPath(arcCenter: dotCenter,
                            radius: dotRadius/2 - dotWidth/2,
                            startAngle: dotStartAngle,
                            endAngle: dotEndAngle,
                            clockwise: true)
        
        path.lineWidth = dotWidth
        counterColor.setStroke()
        counterColor.setFill()
        path.stroke()
        path.fill()

        
        
        //*** Drawing the dashes ***
        
        //Drawing the thin dashes
        
        // init vars for later use
        var nTicks = 0
        var tickWidth = 0.0
        var gapWidth = 0.0
        
        
        radius += 20
        
        path = UIBezierPath(arcCenter: center,
                            radius: radius/2 - arcWidth/2,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
        
        let strokeColor            = UIColor.black.cgColor
        
        let roundThinLayer = CAShapeLayer()
        
        // number of short ticks to draw
        nTicks = 151
        
        // thickness of short ticks
        tickWidth = 0.5
        
        // calculate the gap between ticks
        gapWidth = ((M_PI * Double(radius) / 2) - (tickWidth * Double(nTicks))) / Double(nTicks - 1)
        
        roundThinLayer.path             = path.cgPath
        roundThinLayer.strokeColor      = strokeColor
        roundThinLayer.lineWidth        = 20.0
        roundThinLayer.fillColor        = UIColor.clear.cgColor
        roundThinLayer.lineDashPattern  = [ tickWidth as NSNumber, gapWidth as NSNumber ]
        roundThinLayer.lineDashPhase    = CGFloat(tickWidth / Double(2))
        
        
        self.layer.addSublayer(roundThinLayer)
        
        
        //Drawing the thick dashes
        
        radius += 20
        
        path = UIBezierPath(arcCenter: center,
                            radius: radius/2 - arcWidth/2,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
        
        let roundThickLayer = CAShapeLayer()
        
        
        // number of tall ticks to draw
        nTicks = 7
        
        // thickness of tall ticks
        tickWidth = 1.5
        
        // calculate the gap between ticks
        gapWidth = ((M_PI * Double(radius) / 2) - (tickWidth * Double(nTicks))) / Double(nTicks - 1)
        
        roundThickLayer.path            = path.cgPath
        roundThickLayer.strokeColor     = strokeColor
        roundThickLayer.lineWidth       = 40
        roundThickLayer.fillColor       = UIColor.clear.cgColor
        roundThickLayer.lineDashPattern = [ tickWidth as NSNumber, gapWidth as NSNumber ]
        roundThickLayer.lineDashPhase   = CGFloat(tickWidth / Double(2))
        self.layer.addSublayer(roundThickLayer)
        
        self.clipsToBounds = true
        
        
//        prevLabel.string = "hello"
//        prevLabel.frame               = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 40.0)
//        prevLabel.alignmentMode       = kCAAlignmentCenter
//        prevLabel.contentsScale       = UIScreen.main.scale
//        prevLabel.foregroundColor     = UIColor.white.cgColor
//        prevLabel.font                = UIFont.systemFont(ofSize: 17, weight: UIFontWeightUltraLight)
//        prevLabel.fontSize            = 17.0
//        
//        self.layer.addSublayer(prevLabel)
        
        
    }
}
