//
//  DesignableButton.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/18/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class NoteButton: UIButton {
    
    let roundLayer = CAShapeLayer()
    
    @IBInspectable var makeItRound:Bool = false {
        didSet {
            
//            let buttonCenter = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
//            
//            borderLayer.frame = self.layer.bounds
//            borderLayer.strokeColor = self.circleColor.cgColor
//            borderLayer.fillColor = nil
//            borderLayer.lineWidth = CGFloat(self.circleWidth)
//            let path = UIBezierPath(arcCenter: buttonCenter,
//                                    radius: (self.bounds.width/2) - CGFloat(self.circleWidth),
//                                    startAngle: 0,
//                                    endAngle: CGFloat(2*M_PI),
//                                    clockwise: true)
//            borderLayer.path = path.cgPath
//            
//            
//            self.layer.addSublayer(borderLayer)
            
            
            let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
            let radius: CGFloat = bounds.height
            let arcWidth: CGFloat = 1
            let startAngle: CGFloat = PointerView.radians(0)
            let endAngle: CGFloat = PointerView.radians(360)
            let counterColor = UIColor.red
            
            let path = UIBezierPath(arcCenter: center,
                                    radius: radius/2 - arcWidth/2,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
            
            
            roundLayer.path = path.cgPath
            roundLayer.strokeColor = counterColor.cgColor
            roundLayer.lineWidth = arcWidth
            roundLayer.fillColor = nil
            
            self.layer.addSublayer(roundLayer)
            
        }
    }
    
    
    func selectButton(_ select:Bool) {
        
        if select {
            roundLayer.fillColor = UIColor.green.cgColor
            ()
        } else{
            roundLayer.fillColor = nil
        }
        
        setNeedsDisplay()
        
        
    }
}
