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
    
    @IBOutlet var microphoneVolumeProgressView:UIProgressView?
    
    @IBOutlet weak var predictedLabel: UILabel!
    
    @IBOutlet weak var constantPredictIndicator: UIActivityIndicatorView!

    fileprivate var timerConstantPredict: Timer?
    fileprivate var timerMicrophoneVolume:Timer?
    fileprivate var timerConstantPredictIndicator: Timer?
    var remainingTime = 0
    
    @IBOutlet weak var micPlotView: UIView!
    
    var mic:MicrophoneTracker?
    var trackedAmplitude:Double = 0
    var trackedFrequency:Double = 0
    var trackedSamples = [Float]()
    
    func microphoneTracker(trackedSamples: [Float], samplesBufferSize: Int, trackedFrequency:Double, trackedAmplitude:Double) {
        
        self.trackedSamples = trackedSamples
        self.trackedAmplitude = trackedAmplitude
        self.trackedFrequency = trackedFrequency
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        mic = MicrophoneTracker(bufferSize:1024)
        
        mic?.delegate = self
        mic?.start()
    }
    
    
    override func viewDidAppear(_ animated:Bool){
        
        constantPredictIndicator.isHidden = true
        constantPredictIndicator.stopAnimating()
        
        
        timerConstantPredict = Timer.scheduledTimer(timeInterval: 0.3, target: self,
                                     selector: #selector(autoPredict),
                                     userInfo: nil,
                                     repeats: true)
        
        timerMicrophoneVolume = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                                     selector: #selector(setMicrophoneVolume),
                                                     userInfo: nil,
                                                     repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timerConstantPredict?.invalidate()
        self.timerConstantPredict = nil
        mic?.stop()
    }
    
    @objc func autoPredict() {
        
        self.tick()
        
    }
    
    func setupPlot(_ mic:AKNode) {
        let plot = AKNodeOutputPlot(mic, frame: CGRect(x:0,y:0,width:900,height:micPlotView!.bounds.height))
        plot.plotType = .buffer
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = AKColor.blue
        micPlotView!.addSubview(plot)
    }
    
    //*********************** CONSTANT PREDICT ***************************
    
    func tick() {
        
        if self.trackedAmplitude < 0.1 {
            return
        }
        
        constantPredictIndicator.isHidden = false
        constantPredictIndicator.startAnimating()
        remainingTime = 1
        timerConstantPredictIndicator = Timer.scheduledTimer(timeInterval: 1, target: self,
                                                              selector: #selector(self.countDown),
                                                              userInfo: nil,
                                                              repeats: true)
        
        // prepare json data
        
        let json: [String: Any] = ["samples": self.trackedSamples]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        if let printData = jsonData {
            print (printData)
        }
        
        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/predictData/"
        
        print (urlAdressAppendFftData)
        
        
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
                print ("****** response = \(response)")
                
                
                if let content = data {
                    do {
                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                        
                        if let predictedChord = JsonData["predictedY"] as? Int {
                            
                            DispatchQueue.main.async() {
                                var j = 0
                                for i in 0...(ChromaticViewController.chords.count - 1) {
                                    let chord = ChromaticViewController.chords[i]
                                    if chord.chordNumber == predictedChord {
                                        j = i
                                        break
                                    }
                                }
                                let chord = ChromaticViewController.chords[j]
                                self.predictedLabel.text = chord.name
                            }
                            
                        }
                        
//                        if let number = dictionary["someKey"] as? Double {
//                            // access individual value in dictionary
//                        }
//                        
//                        for (key, value) in dictionary {
//                            // access all key / value pairs in dictionary
//                        }
//                        
//                        if let nestedDictionary = dictionary["anotherKey"] as? [String: Any] {
//                            // access nested dictionary values by key
//                        }
                        
                    } catch {}
                    
                }
                
                //Read the JSON
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
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
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            constantPredictIndicator.stopAnimating()
            constantPredictIndicator.isHidden = true
            self.timerConstantPredictIndicator?.invalidate()
            self.timerConstantPredictIndicator = nil
        }
        
    }
    
    
}

//
//  PredictViewController.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 10/04/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//
//import Foundation
//import UIKit
//import AudioKit
//
//class PredictViewController: UIViewController {
//    
//    @IBOutlet var microphoneVolumeProgressView:UIProgressView?
//    
//    @IBOutlet weak var predictedLabel: UILabel!
//    
//    @IBOutlet weak var constantPredictIndicator: UIActivityIndicatorView!
//    
//    fileprivate var timerConstantPredict: Timer?
//    fileprivate var timerMicrophoneVolume:Timer?
//    fileprivate var timerConstantPredictIndicator: Timer?
//    var remainingTime = 0
//    
//    @IBOutlet weak var micPlotView: UIView!
//    
//    
//    override func viewDidLoad() {
//        //        let micPlot = ChromaticViewController.micPlot
//        //        setupPlot(micPlot!)
//    }
//    
//    override func viewDidAppear(_ animated:Bool){
//        
//        constantPredictIndicator.isHidden = true
//        constantPredictIndicator.stopAnimating()
//        
//        
//        timerConstantPredict = Timer.scheduledTimer(timeInterval: 0.3, target: self,
//                                                    selector: #selector(autoPredict),
//                                                    userInfo: nil,
//                                                    repeats: true)
//        
//        timerMicrophoneVolume = Timer.scheduledTimer(timeInterval: 0.01, target: self,
//                                                     selector: #selector(setMicrophoneVolume),
//                                                     userInfo: nil,
//                                                     repeats: true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.timerConstantPredict?.invalidate()
//        self.timerConstantPredict = nil
//    }
//    
//    @objc func autoPredict() {
//        
//        self.tick()
//        
//    }
//    
//    func setupPlot(_ mic:AKNode) {
//        let plot = AKNodeOutputPlot(mic, frame: CGRect(x:0,y:0,width:900,height:micPlotView!.bounds.height))
//        plot.plotType = .buffer
//        plot.shouldFill = true
//        plot.shouldMirror = true
//        plot.color = AKColor.blue
//        micPlotView!.addSubview(plot)
//    }
//    
//    //*********************** CONSTANT PREDICT ***************************
//    
//    func tick() {
//        
//        if ChromaticViewController.tuner.tracker.amplitude < 0.1 {
//            return
//        }
//        
//        constantPredictIndicator.isHidden = false
//        constantPredictIndicator.startAnimating()
//        remainingTime = 1
//        timerConstantPredictIndicator = Timer.scheduledTimer(timeInterval: 1, target: self,
//                                                             selector: #selector(self.countDown),
//                                                             userInfo: nil,
//                                                             repeats: true)
//        
//        let newFftData = Array((0 ... (512 - 1)).map {
//            
//            index -> Int in
//            let tempArray = (ChromaticViewController.tuner.fft.fftData[index] * (pow(10,16)))
//            return ( Int(tempArray))
//            
//        })
//        
//        print (newFftData)
//        
//        // prepare json data
//        
//        let json: [String: Any] = ["fftData": newFftData]
//        
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        
//        if let printData = jsonData {
//            print (printData)
//        }
//        
//        let urlAdressAppendFftData = "http://" + ServerExchange.urlAddress + "/api/predictData/"
//        
//        print (urlAdressAppendFftData)
//        
//        
//        let url = URL(string: urlAdressAppendFftData)
//        let session = URLSession.shared
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        
//        if let printData = jsonData {
//            request.httpBody = printData
//        } else {
//            return
//        }
//        
//        session.dataTask(with: request, completionHandler:
//            { data, response, error in
//                
//                if error != nil {
//                    print ("Error: \(error)")
//                    return
//                }
//                print ("****** response = \(response)")
//                
//                
//                if let content = data {
//                    do {
//                        let JsonData = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
//                        
//                        if let predictedChord = JsonData["predictedY"] as? Int {
//                            
//                            DispatchQueue.main.async() {
//                                var j = 0
//                                for i in 0...(ChromaticViewController.chords.count - 1) {
//                                    let chord = ChromaticViewController.chords[i]
//                                    if chord.chordNumber == predictedChord {
//                                        j = i
//                                        break
//                                    }
//                                }
//                                let chord = ChromaticViewController.chords[j]
//                                self.predictedLabel.text = chord.name
//                            }
//                            
//                        }
//                        
//                        //                        if let number = dictionary["someKey"] as? Double {
//                        //                            // access individual value in dictionary
//                        //                        }
//                        //
//                        //                        for (key, value) in dictionary {
//                        //                            // access all key / value pairs in dictionary
//                        //                        }
//                        //
//                        //                        if let nestedDictionary = dictionary["anotherKey"] as? [String: Any] {
//                        //                            // access nested dictionary values by key
//                        //                        }
//                        
//                    } catch {}
//                    
//                }
//                
//                //Read the JSON
//                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String {
//                    print("POST:\(postString)")
//                    
//                }
//        }).resume()
//    }
//    
//    
//    func setMicrophoneVolume() {
//        
//        var microphoneVolume = ChromaticViewController.tuner.tracker.amplitude * 10
//        if (microphoneVolume > 1) { microphoneVolume = 1}
//        self.microphoneVolumeProgressView?.progress = Float(microphoneVolume)
//        
//    }
//    
//    func countDown() {
//        
//        self.remainingTime -= 1
//        if (self.remainingTime < 0) {
//            constantPredictIndicator.stopAnimating()
//            constantPredictIndicator.isHidden = true
//            self.timerConstantPredictIndicator?.invalidate()
//            self.timerConstantPredictIndicator = nil
//        }
//        
//    }
//    
//    
//}

