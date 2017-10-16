//
//  StableView.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 30/03/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation

import UIKit


class PointerView: UIView {
    
    var arrowDegree = 90.0
    var arrowLayer = CAShapeLayer()
    let arrow = CAShapeLayer()
    var counterColor: UIColor = UIColor.red
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func draw(_ rect: CGRect) {
        //Drawing a dot at the center
        
        let dotRadius = max(bounds.width/15, bounds.height/15)
        let dotWidth:CGFloat = 10
        let dotCenter = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let dotStartAngle: CGFloat = 0
        let dotEndAngle: CGFloat = CGFloat(2 * M_PI) // π
        
        let path = UIBezierPath(arcCenter: dotCenter,
                            radius: dotRadius/2,
                            startAngle: dotStartAngle,
                            endAngle: dotEndAngle,
                            clockwise: true)
        
        path.lineWidth = dotWidth
        counterColor.setStroke()
        counterColor.setFill()
        path.stroke()
        path.fill()
        
        arrowLayer.frame = CGRect(x:bounds.width/2, y: bounds.height/2, width: bounds.width, height: bounds.height)
        
        arrow.path = UIBezierPath(rect: CGRect(x: 0, y:0 - 1, width: -bounds.width/2, height: 1)).cgPath
        arrow.backgroundColor = UIColor.red.cgColor
        arrow.fillColor = UIColor.clear.cgColor
        arrow.strokeColor = counterColor.cgColor
        arrow.anchorPoint = CGPoint(x:0.5, y:0.5)
        arrow.lineWidth = 3
        arrow.setAffineTransform(CGAffineTransform(rotationAngle:PointerView.radians(arrowDegree)))
        arrowLayer.addSublayer(arrow)
        
        self.layer.addSublayer(arrowLayer)
    }
    
    
    func drawPointerAt (_ degreeToDraw: Double) {
        UIView.animate(withDuration: 5, animations: {
            self.arrow.setAffineTransform(CGAffineTransform(rotationAngle:PointerView.radians(degreeToDraw)))
        })
    }
    
    static func radians(_ degrees: Double) -> CGFloat {
        let k = M_PI / 180
        return CGFloat(degrees * k)
    }
}
