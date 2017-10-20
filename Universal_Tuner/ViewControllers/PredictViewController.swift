//
//  PredictViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 10/04/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class PredictViewController: UIViewController, MicrophoneTrackerDelegate {
    
    var timerConstantPredictIndicator: Timer?
    var remainingTime = 0.0
    var mic = MicrophoneTracker(bufferSize: 20480)
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var trackedSamples = [Float]()
    var samplesBufferSize = 0
    var recordingAudio = false
    
    @IBOutlet weak var micPlotView: UIView!
    @IBOutlet var microphoneVolumeProgressView:UIProgressView?
    @IBOutlet weak var predictedLabel: UILabel!
    @IBOutlet weak var constantPredictIndicator: UIActivityIndicatorView!
    
    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double) {
        DispatchQueue.main.async() {
            self.trackedSamples = trackedSamples
            self.trackedAmplitude = trackedAmplitude
            self.trackedFrequency = trackedFrequency
            self.samplesBufferSize = samplesBufferSize
            self.setMicrophoneVolume()
            if self.recordingAudio == false {
                self.constantPredict()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mic = MicrophoneTracker()
//        MicrophoneTracker.microphone.delegate = self
//        MicrophoneTracker.microphone.start()
        mic.delegate = self
        mic.start()
    }
    
    override func viewDidAppear(_ animated:Bool){
        constantPredictIndicator.isHidden = true
        constantPredictIndicator.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        MicrophoneTracker.microphone.stop()
        mic.stop()
    }
    
    func constantPredict() {
        if self.trackedAmplitude < 0.12 {
            return
        }
        constantPredictIndicator.isHidden = false
        constantPredictIndicator.startAnimating()
        remainingTime = 0.5
        timerConstantPredictIndicator = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                              selector: #selector(self.countDown),
                                                              userInfo: nil,
                                                              repeats: true)
        self.recordingAudio = true
        let json: [String: Any] = ["sample": self.trackedSamples]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/predict/"
        let url = URL(string: urlAdressAppendFftData)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let printData = jsonData {
            request.httpBody = printData
        } else {
            return
        }
        
        session.dataTask(with: request, completionHandler:
            { data, response, error in
                if error != nil {
                    print ("Error: \(error)")
                    return
                }
                print ("****** response = \(String(describing: response))")
                if let content = data {
                    do {
                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                        
                        if let predictedChord = JsonData["predicted_class"] as? Int {
                            DispatchQueue.main.async() {
                                var j = 0
                                for i in 0...(Chord.chords.count - 1) {
                                    let chord = Chord.chords[i]
                                    if chord.chordNumber == predictedChord {
                                        j = i
                                        break
                                    }
                                }
                                let chord = Chord.chords[j]
                                self.predictedLabel.text = chord.name
                            }
                        }
                    } catch {}
                }
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String? {
                    print("POST:\(postString)")

                }
        }).resume()
    }
    
    func setMicrophoneVolume() {
        var microphoneVolume = self.trackedAmplitude * 10
        if (microphoneVolume > 1) { microphoneVolume = 1}
        self.microphoneVolumeProgressView?.progress = Float(microphoneVolume)
    }
    
    func countDown() {
        self.remainingTime -= 0.1
        if (self.remainingTime < 0) {
            constantPredictIndicator.stopAnimating()
            constantPredictIndicator.isHidden = true
            self.timerConstantPredictIndicator?.invalidate()
            self.timerConstantPredictIndicator = nil
            recordingAudio = false
        }
    }
    
}

