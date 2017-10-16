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

