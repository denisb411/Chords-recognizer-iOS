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
    
    var mic:MicrophoneTracker?
    var micTracker:AKMicrophone?
    var tracker: AKFrequencyTracker?
    var silence: AKBooster?
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var trackedSamples = [Float]()
    var samplesBufferSize = 0
    static var chords = [Chord]()
    let minimum = Double(50)
    let maximum = Double(2000)
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var nearestPitchLabel: UILabel!
    @IBOutlet weak var stableView: StableView!
    @IBOutlet weak var pointerView: PointerView!
    @IBOutlet weak var currentPitch: UILabel!
    @IBOutlet weak var fftButton: UIButton!
    
    override func viewDidLoad() {
        ChromaticViewController.chords += [
            Chord(name: "C", image: "C-1.PNG"),
            Chord(name: "Cm", image: "Cm-1.PNG"),
            Chord(name: "C7", image: "C7-1.PNG"),
            Chord(name: "Cm7", image: "Cm7-1.PNG"),
            Chord(name: "C#", image: "C#-1.PNG"),
            Chord(name: "C#m", image: "C#m-1.PNG"),
            Chord(name: "C#7", image: "C#7-1.PNG"),
            Chord(name: "C#m7", image: "C#m7-1.PNG"),
            Chord(name: "D", image: "D-1.PNG"),
            Chord(name: "Dm", image: "Dm-1.PNG"),
            Chord(name: "D7", image: "D7-1.PNG"),
            Chord(name: "Dm7", image: "Dm7-1.PNG"),
            Chord(name: "D#", image: "D#-1.PNG"),
            Chord(name: "D#m", image: "D#m-1.PNG"),
            Chord(name: "D#7", image: "D#7-1.PNG"),
            Chord(name: "D#m7", image: "D#m7-1.PNG"),
            Chord(name: "E", image: "E-1.PNG"),
            Chord(name: "Em", image: "Em-1.PNG"),
            Chord(name: "E7", image: "E7-1.PNG"),
            Chord(name: "Em7", image: "Em7-1.PNG"),
            Chord(name: "F", image: "F-1.PNG"),
            Chord(name: "Fm", image: "Fm-1.PNG"),
            Chord(name: "F7", image: "F7-1.PNG"),
            Chord(name: "Fm7", image: "Fm7-1.PNG"),
            Chord(name: "F#", image: "F#-1.PNG"),
            Chord(name: "F#m", image: "F#m-1.PNG"),
            Chord(name: "F#7", image: "F#7-1.PNG"),
            Chord(name: "F#m7", image: "F#m7-1.PNG"),
            Chord(name: "G", image: "G-1.PNG"),
            Chord(name: "Gm", image: "Gm-1.PNG"),
            Chord(name: "G7", image: "G7-1.PNG"),
            Chord(name: "Gm7", image: "Gm7-1.PNG"),
            Chord(name: "G#", image: "G#-1.PNG"),
            Chord(name: "G#m", image: "G#m-1.PNG"),
            Chord(name: "G#7", image: "G#7-1.PNG"),
            Chord(name: "G#m7", image: "G#m7-1.PNG"),
            Chord(name: "A", image: "A-1.PNG"),
            Chord(name: "Am", image: "Am-1.PNG"),
            Chord(name: "A7", image: "A7-1.PNG"),
            Chord(name: "Am7", image: "Am7-1.PNG"),
            Chord(name: "A#", image: "A#-1.PNG"),
            Chord(name: "A#m", image: "A#m-1.PNG"),
            Chord(name: "A#7", image: "A#7-1.PNG"),
            Chord(name: "A#m7", image: "A#m7-1.PNG"),
            Chord(name: "B", image: "B-1.PNG"),
            Chord(name: "Bm", image: "Bm-1.PNG"),
            Chord(name: "B7", image: "B7-1.PNG"),
            Chord(name: "Bm7", image: "Bm7-1.PNG"),
        ]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mic?.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mic = MicrophoneTracker(bufferSize: 1024)
        mic?.delegate = self
        mic?.start()
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
