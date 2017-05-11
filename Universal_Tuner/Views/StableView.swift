//
//  StableView.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 30/03/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation

import UIKit


class StableView: UIView {
    
    var arrowLayer = CALayer()
            
    var counterColor: UIColor = UIColor.orange
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override func draw(_ rect: CGRect) {
        
        // Drawing the circle line
        
        let roundLayer = CAShapeLayer()
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        var radius: CGFloat = bounds.height
        let arcWidth: CGFloat = 1
        let startAngle: CGFloat = PointerView.radians(180)
        let endAngle: CGFloat = PointerView.radians(360)
        let counterColor = UIColor.red
        
        var path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        
        roundLayer.path = path.cgPath
        roundLayer.strokeColor = counterColor.cgColor
        roundLayer.lineWidth = arcWidth
        roundLayer.fillColor = nil
        
        self.layer.addSublayer(roundLayer)
        
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
                
        
    }
    
}
