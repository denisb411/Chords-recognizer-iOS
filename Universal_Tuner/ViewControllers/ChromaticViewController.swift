//
//  ViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 21/03/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import UIKit
import AudioKit


class ChromaticViewController: UIViewController, MicrophoneTrackerDelegate {
    
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var trackedSamples = [Float]()
    var samplesBufferSize = 0
    let minimum = Double(50)
    let maximum = Double(2000)
    var mic:MicrophoneTracker!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var nearestPitchLabel: UILabel!
    @IBOutlet weak var pointerView: PointerView!
    @IBOutlet weak var currentPitch: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
//        mic = MicrophoneTracker(bufferSize: 1024)
        mic.stop()
//        MicrophoneTracker.microphone.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        MicrophoneTracker.microphone.delegate = self
//        MicrophoneTracker.microphone.start()
        mic = MicrophoneTracker(bufferSize: 1024)
        mic.delegate = self
        mic.start()
    }
    
    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double) {
        self.trackedSamples = trackedSamples
        self.trackedAmplitude = trackedAmplitude
        self.trackedFrequency = trackedFrequency
        self.samplesBufferSize = samplesBufferSize
        
        DispatchQueue.main.async() {
            /* Find nearest pitch. */
            let pitch = Pitch.nearest(trackedFrequency)
            
            /* Calculate the distance. */
            let distance = trackedFrequency - pitch.frequency
            
            if trackedAmplitude < 0.05 {
                return
            }
            
            self.frequencyLabel.text = String(format:"%.4f", trackedFrequency)
            self.amplitudeLabel.text = String(format:"%.4f", trackedAmplitude)
            self.nearestPitchLabel.text = String(pitch.description)
            self.currentPitch.text =  String(describing: pitch.note)
            
            let degreeToDraw = self.calculateDegreeByDistance(nearestPitch: pitch, distance: distance)
            self.pointerView.drawPointerAt(degreeToDraw)
        }
        
    }
    
    func calculateDegreeByDistance (nearestPitch: Pitch, distance: Double) -> Double {
        
        var distanceOnRule = 0.0
        var distanceState = true  //true means that the distance is negative
        var degreeToDraw = 0.0
        
        if distance < 0 {
            distanceState = true
        } else {
            distanceState = false
        }
        
        if distanceState {
            let distancePrev = nearestPitch.frequency - (nearestPitch - 1).frequency
            let ruleOfDistance = distancePrev / 90  //calculate the distance of each degree
            distanceOnRule = distance/ruleOfDistance
        } else {
            let distanceNext = (nearestPitch + 1).frequency - nearestPitch.frequency
            let ruleOfDistance = distanceNext / 90
            distanceOnRule = distance/ruleOfDistance
        }
        degreeToDraw = 90 + distanceOnRule
        
        return degreeToDraw
    }
}
