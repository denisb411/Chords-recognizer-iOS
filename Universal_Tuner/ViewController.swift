//
//  ViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 21/03/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import UIKit

@IBDesignable
class ViewController: UIViewController, TunerDelegate {
    
    let tuner = Tuner()
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var nearestPitch: UILabel!
    @IBOutlet weak var distanceFromNearest: UILabel!
    
    @IBOutlet weak var stableView: StableView!
    
    @IBOutlet weak var pointerView: PointerView!
    
    @IBOutlet weak var prevPitch: UILabel!
    @IBOutlet weak var nextPitch: UILabel!
    @IBOutlet weak var currectPitch: UILabel!
    
    
    
//    let analogView = AnalogView(frame: CGRect(x: 20, y: 200, width: 340, height: 300))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tuner.start()
        tuner.delegate = self
        
    }
    
    func tunerDidMeasurePitch(_ pitch: Pitch, withDistance distance: Double,
                              amplitude: Double, frequency: Double) {
        
        if amplitude < 0.05 {
            return
        }
        
        frequencyLabel.text = String(format:"%.4f", frequency)
        amplitudeLabel.text = String(format:"%.4f", amplitude)
        nearestPitch.text = String(pitch.description)
        distanceFromNearest.text = String(format:"%.4f", abs(distance))
        
//        currectPitch.text = String(pitch.description)
//        prevPitch.text = String((pitch - 1).description)
//        nextPitch.text = String((pitch + 1).description)
        
        
        
    }
    
    @IBAction func rotateButton() {
        
        pointerView.rotateButton()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

