//
//  AnalogView.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 21/03/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AnalogView: UIView {
    
    fileprivate let thickHorizontalLayer = CAShapeLayer()
    fileprivate let thinHorizontalLayer = CAShapeLayer()
    
    @IBInspectable var thickYCoord = 50.0
    @IBInspectable let thinYCoord = 52.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let thickDashesPath = UIBezierPath()
        thickDashesPath.move(to: CGPoint(x: 0, y: thickYCoord)) //left
        
        thickDashesPath.addLine(to: CGPoint(x: 340, y: thickYCoord)) //right
        
        //thickHorizontalLayer.frame           = frame
        thickHorizontalLayer.path            = thickDashesPath.cgPath
        thickHorizontalLayer.strokeColor     = UIColor.black.cgColor //dashes color
        thickHorizontalLayer.lineWidth       = 20
        thickHorizontalLayer.lineDashPattern = [ 1, 83.5 ]
        //thickHorizontalLayer.lineDashPhase   = 0.25
        
        self.layer.addSublayer(thickHorizontalLayer)
        
        let thinDashesPath = UIBezierPath()
        thinDashesPath.move(to: CGPoint(x: 0, y: thinYCoord)) //esquerda
        thinDashesPath.addLine(to: CGPoint(x: 340, y: thinYCoord)) //direita
        
        //thinHorizontalLayer.frame            = frame
        thinHorizontalLayer.path             = thinDashesPath.cgPath
        thinHorizontalLayer.strokeColor      = UIColor.black.cgColor
        thinHorizontalLayer.lineWidth        = 15.0
        thinHorizontalLayer.fillColor        = UIColor.clear.cgColor
        thinHorizontalLayer.lineDashPattern  = [ 0.5, 7.95]
        //thinHorizontalLayer.lineDashPhase    = 0.25
        
        self.layer.addSublayer(thinHorizontalLayer)
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
