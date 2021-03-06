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
    var trackedSamples = [Float]()
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var samplesBufferSize:Int
    var delegate:MicrophoneTrackerDelegate?
    var silence:AKBooster?
    var akMicTracker:AKMicrophoneTracker
    
    //static let microphone = MicrophoneTracker()
    
    init(bufferSize:Int = 20480) {
        self.samplesBufferSize = bufferSize
        mic = AKMicrophone()
        silence = AKBooster(mic, gain:0)
        akMicTracker = AKMicrophoneTracker()
        installTap(mic)
    }
    
    func start(){
        AudioKit.output = silence
        AudioKit.start()
        akMicTracker.start()
    }
    
    func stop() {
        mic.avAudioNode.removeTap(onBus: 0)
        mic.stop()
        //AudioKit.stop()  // <--- if this is called installTap doesn't work anymore.
    }
    
    func installTap(_ input:AKMicrophone) {
        input.avAudioNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(self.samplesBufferSize), format: AudioKit.format) { [weak self] (buffer, time) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.signalTracker(didReceivedBuffer: buffer, atTime: time)
        }
    }
    
    func signalTracker(didReceivedBuffer buffer: AVAudioPCMBuffer, atTime time: AVAudioTime){
        let elements = UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:self.samplesBufferSize)
        self.trackedSamples.removeAll()
        for i in 0..<self.samplesBufferSize {
            self.trackedSamples.append(elements[i])
        }
        self.trackedAmplitude = akMicTracker.amplitude
        self.trackedFrequency = akMicTracker.frequency
        delegate!.microphoneTracker(trackedSamples: self.trackedSamples, samplesBufferSize: self.samplesBufferSize, trackedFrequency:self.trackedFrequency, trackedAmplitude:self.trackedAmplitude)
        
    }

    
}
