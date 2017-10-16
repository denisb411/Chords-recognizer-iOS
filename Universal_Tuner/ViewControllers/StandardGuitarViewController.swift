

//
//
//  StandardGuitarViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 01/04/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.


import Foundation
import UIKit
import AVFoundation
import AudioKit

class StandandGuitarViewController: UIViewController, MicrophoneTrackerDelegate {
    
    var mic:MicrophoneTracker?
    
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var trackedSamples = [Float]()
    var samplesBufferSize = 0
    
    @IBAction func LowEButton(_ sender: Any) {
        
        if let button = sender as? NoteButton {
            if !button.isSelected {
                // set selected
                button.isSelected = true
                button.selectButton(true)
                button.isHighlighted = true
                print(button.isSelected)
            } else {
                // set deselected
                button.isSelected = false
                button.selectButton(false)
                button.isHighlighted = false
                
                print(button.isSelected)
                
            }
        }
    }
    
    @IBOutlet var trackedAmplitudeLabel:UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        mic = MicrophoneTracker()
        mic?.delegate = self
        mic?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        mic?.stop()
    }
    
    
    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double) {
        
        self.trackedSamples = trackedSamples
        self.trackedAmplitude = trackedAmplitude
        self.trackedFrequency = trackedFrequency
        self.samplesBufferSize = samplesBufferSize
        
        DispatchQueue.main.async() {
            self.trackedAmplitudeLabel.text = String(format:"%.4f", self.trackedAmplitude)
        }
        
    }
}

