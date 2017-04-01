/*
 * Copyright (c) 2016 Tim van Elsloo
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import AudioKit
import Foundation

protocol TunerDelegate {
    /**
     * The tuner calls this delegate function when it detects a new pitch. The
     * Pitch object is the nearest note (A-G) in the nearest octave. The
     * distance is between the actual tracked frequency and the nearest note.
     * Finally, the amplitude is the volume (note: of all frequencies).
     */
    func tunerDidMeasurePitch(_ pitch: Pitch, withDistance distance: Double,
                              amplitude: Double, frequency: Double, distanceState:Bool, distanceOnRule:Double)
    
}

class Tuner {
    var delegate: TunerDelegate?
    
    let minimum = Double(50)
    let maximum = Double(2000)
    
    var negativeDistance = false
    var positiveDistace = true
    
    fileprivate var timer: Timer?
    var mic: AKMicrophone
    var tracker: AKFrequencyTracker
    fileprivate var silence: AKBooster
    
    init(){
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic, hopSize: minimum, peakCount: maximum)
        silence = AKBooster(tracker, gain:0)
    }
    
    func start(){
        AudioKit.output = silence
        mic.start()
        AudioKit.start()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                     selector: #selector(analyse),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    func stop(){
        mic.stop()
        AudioKit.stop()
        timer?.invalidate()
    }
    
    @objc func analyse() {
        
        self.tick()
        
    }
    
    func tick() {
        /* Read frequency and amplitude from the analyzer. */
        let frequency = tracker.frequency
        let amplitude = tracker.amplitude
        var distanceOnRule = 0.0
        var distanceState = true  //true means that the distance is negative
        
        /* Find nearest pitch. */
        let pitch = Pitch.nearest(frequency)
        
        /* Calculate the distance. */
        let distance = frequency - pitch.frequency
        
        if distance < 0 {
            distanceState = true
        } else {
            distanceState = false
        }
        
        if distanceState {
            let distancePrev = pitch.frequency - (pitch - 1).frequency
            let ruleOfDistance = distancePrev / 90  //calculate the distance of each degree
            distanceOnRule = distance/ruleOfDistance
        } else {
            let distanceNext = (pitch + 1).frequency - pitch.frequency
            let ruleOfDistance = distanceNext / 90
            distanceOnRule = distance/ruleOfDistance
        }
        
        
        
        
        /* Call the delegate. */
        self.delegate?.tunerDidMeasurePitch(pitch, withDistance: distance,
                                            amplitude: amplitude, frequency: frequency, distanceState:distanceState, distanceOnRule:distanceOnRule)
    }
    
}
