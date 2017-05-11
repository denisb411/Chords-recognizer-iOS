//
//  DesignableButton.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/18/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonX: UIButton {
    
    let borderLayer = CAShapeLayer()
    
    enum FromDirection:Int {
        case Top = 0
        case Right = 1
        case Bottom = 2
        case Left = 3
    }
    
    var direction: FromDirection = .Left
    var alphaBefore: CGFloat = 1
    
    @IBInspectable var animate: Bool = false
    @IBInspectable var animateDelay: Double = 0.2
    @IBInspectable var animateFrom: Int {
        get {
            return direction.rawValue
        }
        set (directionIndex) {
            direction = FromDirection(rawValue: directionIndex) ?? .Left
        }
    }
    
    @IBInspectable var popIn: Bool = false
    @IBInspectable var popInDelay: Double = 0.4
    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        
        if animate {
            let originalFrame = frame
            
            if direction == .Bottom {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y + 200, width: frame.width, height: frame.height)
            }
            
            UIView.animate(withDuration: 0.3, delay: animateDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.frame = originalFrame
            }, completion: nil)
        }
        
        if popIn {
            transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alphaBefore = alpha
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.4
        })
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = self.alphaBefore
        })
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var widthBorder:Double = 0.0
    @IBInspectable var widthColor:UIColor = UIColor.black
    
    @IBInspectable var makeItRound:Bool = false {
        didSet {
            
            let buttonCenter = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            
            borderLayer.frame = self.layer.bounds
            borderLayer.strokeColor = self.widthColor.cgColor
            borderLayer.fillColor = nil
            borderLayer.lineWidth = CGFloat(self.widthBorder)
            let path = UIBezierPath(arcCenter: buttonCenter,
                                    radius: self.bounds.width/2 - self.borderWidth,
                                    startAngle: 0,
                                    endAngle: CGFloat(2*M_PI),
                                    clockwise: true)
            borderLayer.path = path.cgPath
            self.layer.addSublayer(borderLayer)
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    func selectButton(_ select:Bool) {
    
        if select {
            borderLayer.fillColor = UIColor.green.cgColor
            setNeedsDisplay()
        } else{
            borderLayer.fillColor = nil
            setNeedsDisplay()
        }
        
        
    }
}
