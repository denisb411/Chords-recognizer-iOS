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

protocol MicrophoneTrackerDelegate {
    
    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double)
    
}

class MicrophoneTracker {
    
    
    var mic:AKMicrophone
//    var akMicTracker:AKMicrophoneTracker?

    var trackedSamples = [Float]()
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0

    var samplesBufferSize:Int
    var akMicTracker:AKMicrophoneTracker
    
    var delegate:MicrophoneTrackerDelegate?
    
    init(bufferSize:Int = 8192) {
        self.samplesBufferSize = bufferSize
        mic = AKMicrophone()
        akMicTracker = AKMicrophoneTracker()
    }
    
    func start(){
        installTap(mic)
        akMicTracker.start()
        
    }
    
    func stop() {
        akMicTracker.stop()
        mic.avAudioNode.removeTap(onBus: 0)
        mic.stop()
    }
    
    func installTap(_ input:AKMicrophone) {
        
        input.avAudioNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(self.samplesBufferSize), format: AudioKit.format) { [weak self] (buffer, time) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.signalTracker(didReceivedBuffer: buffer, atTime: time)
        }
        
        input.start()
        
    }
    
    
    func signalTracker(didReceivedBuffer buffer: AVAudioPCMBuffer, atTime time: AVAudioTime){
        
        let elements = UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:self.samplesBufferSize)
        
        
        for i in 0..<self.samplesBufferSize {
            self.trackedSamples.append(elements[i])
        }
        
//        var rms: Float = 0
//        
//        for i in 0 ..< Int(self.samplesBufferSize) {
//            rms += pow(Float((buffer.floatChannelData?.pointee[i]) ?? 0.0), 2)
//        }
//
//        self.trackedAmplitude = 20*log10(rms); //calculate decibels
        
        self.trackedAmplitude = akMicTracker.amplitude
        self.trackedFrequency = akMicTracker.frequency
//
        delegate!.microphoneTracker(trackedSamples: self.trackedSamples, samplesBufferSize: self.samplesBufferSize, trackedFrequency:self.trackedFrequency, trackedAmplitude:self.trackedAmplitude)
        
    }

    
}
