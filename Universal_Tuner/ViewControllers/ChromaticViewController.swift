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
    fileprivate var silence: AKBooster?
    
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
    @IBOutlet weak var prevPitch: UILabel!
    @IBOutlet weak var nextPitch: UILabel!
    @IBOutlet weak var currentPitch: UILabel!
    @IBOutlet weak var fftButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        ChromaticViewController.chords += [
            Chord(name: "C"),
            Chord(name: "Cm"),
            Chord(name: "C7"),
            Chord(name: "Cm7"),
            Chord(name: "C#"),
            Chord(name: "C#m"),
            Chord(name: "C#7"),
            Chord(name: "C#m7"),
            Chord(name: "D"),
            Chord(name: "Dm"),
            Chord(name: "D7"),
            Chord(name: "Dm7"),
            Chord(name: "D#"),
            Chord(name: "D#m"),
            Chord(name: "D#7"),
            Chord(name: "D#m7"),
            Chord(name: "E"),
            Chord(name: "Em"),
            Chord(name: "E7"),
            Chord(name: "Em7"),
            Chord(name: "F"),
            Chord(name: "Fm"),
            Chord(name: "F7"),
            Chord(name: "Fm7"),
            Chord(name: "F#"),
            Chord(name: "F#m"),
            Chord(name: "F#7"),
            Chord(name: "F#m7"),
            Chord(name: "G"),
            Chord(name: "Gm"),
            Chord(name: "G7"),
            Chord(name: "Gm7"),
            Chord(name: "G#"),
            Chord(name: "G#m"),
            Chord(name: "G#7"),
            Chord(name: "G#m7"),
            Chord(name: "A"),
            Chord(name: "Am"),
            Chord(name: "A7"),
            Chord(name: "Am7"),
            Chord(name: "A#"),
            Chord(name: "A#m"),
            Chord(name: "A#7"),
            Chord(name: "A#m7"),
            Chord(name: "B"),
            Chord(name: "Bm"),
            Chord(name: "B7"),
            Chord(name: "Bm7"),
        ]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mic?.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mic = MicrophoneTracker(bufferSize: 16384)
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
            
//            if trackedAmplitude < 0.05 {
//                return
//            }
            
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




////  ViewController.swift
////  Universal_Tuner
////
////  Created by Denis França Candido on 21/03/17.
////  Copyright © 2017 Denis França Candido. All rights reserved.
//import UIKit
//import AudioKit
//
//
//class ChromaticViewController: UIViewController, TunerDelegate {
//    
//    static let tuner = Tuner()
//    
//    //    static var micPlot:AKNode?
//    
//    static var chords = [
//        Chord(name: "C"),
//        Chord(name: "Cm"),
//        Chord(name: "C7"),
//        Chord(name: "Cm7"),
//        Chord(name: "C#"),
//        Chord(name: "C#m"),
//        Chord(name: "C#7"),
//        Chord(name: "C#m7"),
//        Chord(name: "D"),
//        Chord(name: "Dm"),
//        Chord(name: "D7"),
//        Chord(name: "Dm7"),
//        Chord(name: "D#"),
//        Chord(name: "D#m"),
//        Chord(name: "D#7"),
//        Chord(name: "D#m7"),
//        Chord(name: "E"),
//        Chord(name: "Em"),
//        Chord(name: "E7"),
//        Chord(name: "Em7"),
//        Chord(name: "F"),
//        Chord(name: "Fm"),
//        Chord(name: "F7"),
//        Chord(name: "Fm7"),
//        Chord(name: "F#"),
//        Chord(name: "F#m"),
//        Chord(name: "F#7"),
//        Chord(name: "F#m7"),
//        Chord(name: "G"),
//        Chord(name: "Gm"),
//        Chord(name: "G7"),
//        Chord(name: "Gm7"),
//        Chord(name: "G#"),
//        Chord(name: "G#m"),
//        Chord(name: "G#7"),
//        Chord(name: "G#m7"),
//        Chord(name: "A"),
//        Chord(name: "Am"),
//        Chord(name: "A7"),
//        Chord(name: "Am7"),
//        Chord(name: "A#"),
//        Chord(name: "A#m"),
//        Chord(name: "A#7"),
//        Chord(name: "A#m7"),
//        Chord(name: "B"),
//        Chord(name: "Bm"),
//        Chord(name: "B7"),
//        Chord(name: "Bm7"),
//        ]
//    
//    @IBOutlet weak var frequencyLabel: UILabel!
//    @IBOutlet weak var amplitudeLabel: UILabel!
//    @IBOutlet weak var nearestPitchLabel: UILabel!
//    
//    @IBOutlet weak var stableView: StableView!
//    
//    @IBOutlet weak var pointerView: PointerView!
//    
//    @IBOutlet weak var prevPitch: UILabel!
//    @IBOutlet weak var nextPitch: UILabel!
//    
//    @IBOutlet weak var currentPitch: UILabel!
//    
//    @IBAction func fftButtonPressed(_ sender: Any) { //collect the FFT
//        
//        
//        
//        
//        
//        //        let newFftData = Array((0 ... 511).map {
//        //
//        //            index -> Double in
//        //            if ChromaticViewController.tuner.fft.fftData[index] > 0.00001 {
//        //                return ChromaticViewController.tuner.fft.fftData[index]
//        //            } else {
//        //                return 0
//        //            }
//        //
//        //        })
//        
//        print (ChromaticViewController.tuner.fft.fftData)
//        print (ChromaticViewController.tuner.fft.fftData.count)
//        print (ChromaticViewController.tuner.fft.fftData.max())
//        var fftData = ChromaticViewController.tuner.fft.fftData
//        
//        
//        
//        
//        
//        
//        
//    }
//    @IBOutlet weak var fftButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        ChromaticViewController.tuner.start()
//        ChromaticViewController.tuner.delegate = self
//        //        ChromaticViewController.micPlot = AKMixer(ChromaticViewController.tuner.mic)
//
//    }
//
//    func tunerDidMeasurePitch(_ nearestPitch: Pitch, withDistance distance: Double,
//                              amplitude: Double, frequency: Double) {
//
//        if amplitude < 0.05 {
//            return
//        }
//
//        frequencyLabel.text = String(format:"%.4f", frequency)
//        amplitudeLabel.text = String(format:"%.4f", amplitude)
//        self.nearestPitchLabel.text = String(nearestPitch.description)
//        
//        currentPitch.text =  String(describing: nearestPitch.note)
//        
//        let degreeToDraw = calculateDegreeByDistance(nearestPitch: nearestPitch, distance: distance)
//        
//        pointerView.drawPointerAt(degreeToDraw)
//        
//        
//    }
//    
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//        
//        
//    }
//    
//    
////    override func viewWillDisappear(_ animated: Bool) {
////        ChromaticViewController.tuner.stop()
////    }
//    
//    
//    func calculateDegreeByDistance (nearestPitch: Pitch, distance: Double) -> Double {
//        
//        var distanceOnRule = 0.0
//        var distanceState = true  //true means that the distance is negative
//        var degreeToDraw = 0.0
//        
//        if distance < 0 {
//            distanceState = true
//        } else {
//            distanceState = false
//        }
//        
//        if distanceState {
//            let distancePrev = nearestPitch.frequency - (nearestPitch - 1).frequency
//            let ruleOfDistance = distancePrev / 90  //calculate the distance of each degree
//            distanceOnRule = distance/ruleOfDistance
//        } else {
//            let distanceNext = (nearestPitch + 1).frequency - nearestPitch.frequency
//            let ruleOfDistance = distanceNext / 90
//            distanceOnRule = distance/ruleOfDistance
//        }
//        
//        degreeToDraw = 90 + distanceOnRule
//        
//        
//        return degreeToDraw
//        
//    }
//    
//}


