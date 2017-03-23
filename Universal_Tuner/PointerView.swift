////
////  PointerView.swift
////  Universal_Tuner
////
////  Created by Denis França Candido on 22/03/17.
////  Copyright © 2017 Denis França Candido. All rights reserved.
////
//
//import UIKit
//
//
//@IBDesignable
//class PointerView: UIView {
//    
//    @IBOutlet var analogView:analogView!
//    
//    
//    
//    public override func draw(_ rect: CGRect) {
//        
//        
//        //Dot at the center
//        
//        let dotRadius = max(analogView.bounds.width/15, analogView.bounds.height/15)
//        
//        let dotWidth:CGFloat = 100
//        
//        let dotCenter = CGPoint(x:analogView.bounds.width/2, y: analogView.bounds.height)
//        
//        let dotStartAngle: CGFloat = 0
//        let dotEndAngle: CGFloat = CGFloat(2 * M_PI) // π
//        
//        path = UIBezierPath(arcCenter: dotCenter,
//                            radius: dotRadius/2 - dotWidth/2,
//                            startAngle: dotStartAngle,
//                            endAngle: dotEndAngle,
//                            clockwise: true)
//        
//        path.lineWidth = dotWidth
//        counterColor.setStroke()
//        path.stroke()
//        
//    }
//    
//    
//    
//}
