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

class MicrophoneTracker {
    
    
    var mic:AKMicrophone?

    var trackedAmplitude:Float = 0
    var trackedSample = [Float]()

    var bufferSize = 8192
    
    @IBOutlet trackedAmplitudeLabel:UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        mic = AKMicrophone()
        
        installTap(mic!)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        mic?.avAudioNode.removeTap(onBus: 0)
    }
    
    func installTap(_ input:AKNode) {
        
        input.avAudioNode.installTap(onBus: 0, bufferSize: self.bufferSize, format: AudioKit.format) { [weak self] (buffer, time) -> Void in
            self?.signalTracker(didReceivedBuffer: buffer, atTime: time)
        }
    }

    init (bufferSize:Float = 8192, delegate){

    }
    
    
    
    func signalTracker(didReceivedBuffer buffer: AVAudioPCMBuffer, atTime time: AVAudioTime){
        
        let elements = UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:self.bufferSize)
        
        for i in 0..<self.bufferSize {
            self.sample.append(elements[i])
        }

        //TODO: check the differences
        //for i in 0 ..< Int(self.bufferSize) {
        //    self.sample.append(Float((buffer.floatChannelData?.pointee[i]) ?? 0.0))
        //}

        //self.trackedAmplitude = getDecibels(fromSignal buffer:buffer, withBufferSize: self.bufferSize)


        //TODO: check if this is valid
        // do a quick calc from the buffer values. Make the RMS
        var rms: Float = 0 
        
        for i in 0 ..< Int(self.bufferSize) {
            rms += pow(Float((buffer.floatChannelData?.pointee[i]) ?? 0.0), 2)
        }
        
        self.trackedAmplitude = 20*log10(rms);

        DispatchQueue.main.async { () -> Void in {
            trackedAmplitudeLabel.text = String(format:"%.4f", trackedAmplitude)
        }

        print (sample)
        print(sample.count)

    }


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
    
}
