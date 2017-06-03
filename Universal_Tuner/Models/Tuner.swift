///*
// * Copyright (c) 2017 Tim van Elsloo and Denis França Candido
// *
// * Permission is hereby granted, free of charge, to any person obtaining a copy
// * of this software and associated documentation files (the "Software"), to deal
// * in the Software without restriction, including without limitation the rights
// * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// * copies of the Software, and to permit persons to whom the Software is
// * furnished to do so, subject to the following conditions:
// *
// * The above copyright notice and this permission notice shall be included in
// * all copies or substantial portions of the Software.
// *
// * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// * SOFTWARE.
// */
//
//import AudioKit
//import Foundation
//
//protocol TunerDelegate {
//    /**
//     * The tuner calls this delegate function when it detects a new pitch. The
//     * Pitch object is the nearest note (A-G) in the nearest octave. The
//     * distance is between the actual tracked frequency and the nearest note.
//     * Finally, the amplitude is the volume (note: of all frequencies).
//     */
//    func tunerDidMeasurePitch(_ pitch: Pitch, withDistance distance: Double,
//                              amplitude: Double, frequency: Double)
//    
//}
//
//class Tuner: MicrophoneTrackerDelegate {
//    var delegate: TunerDelegate?
//    
//    let minimum = Double(50)
//    let maximum = Double(2000)
//    
//    var negativeDistance = false
//    var positiveDistace = true
//    
//    fileprivate var timer: Timer?
//    var mic:MicrophoneTracker?
//    
//    var trackedAmplitude:Double = 0
//    var trackedFrequency:Double = 0
//    var trackedSamples = [Float]()
//    
//    
//    init(){
//        mic = MicrophoneTracker(bufferSize: 1024)
//        mic?.delegate = self
//    }
//    
//    func start(){
//        mic?.start()
//        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
//                                     selector: #selector(analyse),
//                                     userInfo: nil,
//                                     repeats: true)
//        
//    }
//    
//    func stop(){
//        mic?.stop()
//        timer?.invalidate()
//    }
//    
//    @objc func analyse() {
//        
//        self.tick()
//        
//    }
//    
//    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double) {
//        
//        self.trackedSamples = trackedSamples
//        self.trackedAmplitude = trackedAmplitude
//        self.trackedFrequency = trackedFrequency
//        
//    }
//    
//    func tick() {
//        /* Read frequency and amplitude from the analyzer. */
//        let frequency = self.trackedFrequency
//        let amplitude = self.trackedAmplitude
//        
//        //let fft = AKFFTTap(mic)
//        
//        /* Find nearest pitch. */
//        let pitch = Pitch.nearest(frequency)
//        
//        /* Calculate the distance. */
//        let distance = frequency - pitch.frequency
//        
//        /* Call the delegate. */
//        self.delegate?.tunerDidMeasurePitch(pitch, withDistance: distance,
//                                            amplitude: amplitude, frequency: frequency)
//    }
//    
//}


/*
 * Copyright (c) 2017 Tim van Elsloo and Denis França Candido
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
                              amplitude: Double, frequency: Double)
    
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
    var fft:AKFFTTap
    
    init(){
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic, hopSize: minimum, peakCount: maximum)
        silence = AKBooster(tracker, gain:0)
        fft = AKFFTTap(mic)
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
        
        //let fft = AKFFTTap(mic)
        
        /* Find nearest pitch. */
        let pitch = Pitch.nearest(frequency)
        
        /* Calculate the distance. */
        let distance = frequency - pitch.frequency
        
        /* Call the delegate. */
        self.delegate?.tunerDidMeasurePitch(pitch, withDistance: distance,
                                            amplitude: amplitude, frequency: frequency)
    }
    
}

