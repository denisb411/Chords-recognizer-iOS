//
//  ViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 21/03/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TunerDelegate {
    
    let tuner = Tuner()
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var nearestPitch: UILabel!
    @IBOutlet weak var distanceFromNearest: UILabel!
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tuner.start()
        tuner.delegate = self
    }
    
    func updateUI() {
        
        
        
    }
    
    func tunerDidMeasurePitch(_ pitch: Pitch, withDistance distance: Double,
                              amplitude: Double, frequency: Double) {
        
        if amplitude < 0.1 {
            return
        }
        
        frequencyLabel.text = String(format:"%.4f", frequency)
        amplitudeLabel.text = String(format:"%.4f", amplitude)
        nearestPitch.text = String(pitch.description)
        distanceFromNearest.text = String(format:"%.4f", abs(distance))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

