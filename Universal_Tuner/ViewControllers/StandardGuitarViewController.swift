//
//  StandardGuitarViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 01/04/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioKit

class StandandGuitarViewController: UIViewController, MicrophoneTrackerDelegate {
    
    
    var mic = MicrophoneTracker(bufferSize: 8192)

    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var trackedSamples = [Float]()
    
    var counter = 0
    
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
        
        mic.delegate = self
        mic.start()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        mic.stop()

    }
    
    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double) {
        
        DispatchQueue.main.async() {
            self.trackedAmplitudeLabel.text = String(format:"%.4f", trackedAmplitude)
        }
        
        self.trackedSamples = trackedSamples
        self.trackedAmplitude = trackedAmplitude
        self.trackedFrequency = trackedFrequency
        
    }

}
        
        
//        mic?.avAudioNode.removeTap(onBus: 0)
//    }
//    
//    func installTap(_ input:AKNode) {
//        
//        input.avAudioNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(self.bufferSize), format: AudioKit.format) { [weak self] (buffer, time) -> Void in
//            self?.signalTracker(didReceivedBuffer: buffer, atTime: time)
//        }
//    }
//    
//    
//
//    func signalTracker(didReceivedBuffer buffer: AVAudioPCMBuffer, atTime time: AVAudioTime){
//        
//        let elements = UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:self.bufferSize)
//        
//        for i in 0..<self.bufferSize {
//            self.trackedSample.append(elements[i])
//        }
//
//        //TODO: check the differences
//        //for i in 0 ..< Int(self.bufferSize) {
//        //    self.sample.append(Float((buffer.floatChannelData?.pointee[i]) ?? 0.0))
//        //}
//
//        //self.trackedAmplitude = getDecibels(fromSignal buffer:buffer, withBufferSize: self.bufferSize)
//
//
//        //TODO: check if this is valid
//        // do a quick calc from the buffer values. Make the RMS
//        var rms: Float = 0 
//        
//        for i in 0 ..< Int(self.bufferSize) {
//            rms += pow(Float((buffer.floatChannelData?.pointee[i]) ?? 0.0), 2)
//        }
//        
//        self.trackedAmplitude = 20*log10(rms); //calculate decibels
////        self.trackedAmplitude = rms; //calculate decibels
//        
////        let magnitude = max(rms, 0.000000000001)
////        self.trackedAmplitude =  10 * log10f(magnitude)
//
//
//        DispatchQueue.main.async() {
//            self.trackedAmplitudeLabel.text = String(format:"%.4f", self.trackedAmplitude)
//        }
//        
//        if counter == 0 { print (self.trackedSample) }
////        print(self.trackedSample.count)
//        
//        self.counter = 1
//
//
//    }

    
//    func getDecibels(fromSignal buffer:UnsafeMutablePointer<Float>, withBufferSize: Float) {
//        
//        var one = 1.0
//        var meanVal = 1.0
//        var tiny = 0.1
//        var lastdbValue = 0.0
//        
//        vDSP_vsq(buffer, 1, buffer, 1, vDSP_Length(self.bufferSize))
//        
//        vDSP_meanv(buffer, 1, &Float(meanVal), vDSP_Length(self.bufferSize))
//        
//        vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0)
//        
//    }

    //TODO: Translate this Obj-C function
    //
    //- (float)getDecibelsFromSignal:(float**)buffer withBufferSize:(UInt32)bufferSize {
    //
    //    // Decibel Calculation.
    //
    //    float one = 1.0;
    //    float meanVal = 0.0;
    //    float tiny = 0.1;
    //    float lastdbValue = 0.0;
    //
    //    vDSP_vsq(buffer[0], 1, buffer[0], 1, bufferSize);
    //
    //    vDSP_meanv(buffer[0], 1, &meanVal, bufferSize);
    //
    //    vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
    //
    //
    //    // Exponential moving average to dB level to only get continous sounds.
    //
    //    float currentdb = 1.0 - (fabs(meanVal) / 100);
    //
    //    if (lastdbValue == INFINITY || lastdbValue == -INFINITY || isnan(lastdbValue)) {
    //        lastdbValue = 0.0;
    //    }
    //
    //    float dbValue = ((1.0 - tiny) * lastdbValue) + tiny * currentdb;
    //
    //    lastdbValue = dbValue;
    //
    //    return dbValue;
    //}

